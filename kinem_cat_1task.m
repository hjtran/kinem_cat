function varargout = kinem_cat_1task(varargin)
% Created by Joey Tran in December 2013
% For info or help, email j.tran4418@gmail.com
% Main program: Version 2.03 Updated 6/05/2014
% Running program without arguments will prompt for recording number
% and task, and stepNum will be used from parameters. Running as function
% first argument will be recording number, second argument will be task,
% third number will be step number. Any number of arguments will run

%Parameters ---------------------------------------------------------------
toeFile = 'Toe.txt';    % name of toe file to analyze beg. and end of steps
angleOrLED = 'LED'; % is file Angle or LED, CASE SENSITIVE
binSize = 20; % number of bins
stepNum = 3; % what number step of trials to analyze
clusterOrNot = 0; % 1 to cluster, 0 to not
textFiles = {'Back.txt', ...
    };
flatAdjustment = 0; % Adjustment for tasks
prop = 'Px'; % Property to analyze, possible options include:
% For LED:
% Px Py Pz
% Vx Vy Vz
% Ax Ay Az
% For Angle:
% Angle C.Angle S.Angle
% Vel Acc
% CASE SENSITIVE
%End Parameters -----------------------------------------------------------
% These parameters are overwritten if parameters is given as an input.

switch nargin
    case 0
        recNum = input('Recording Number? ','s');
        task = input('Task? ', 's');
    case 1
        recNum = varargin{1};
        task = input('Task? ', 's');
    case 2
        if varargin{1} ~= 'False'
        recNum = varargin{1};
        task = varargin{2};
        elseif varargin{1} == 'False'
            params = varargin{2};    % params = { toeText, angleOrLED, binSize, stepNum, Analysis File,
            % Property, tasks, numTasks, oneFile }
            toeFile = params{1};
            angleOrLED = params{2};
            binSize = params{3};
            stepNum = params{4};
            textFiles = params(5);
            prop = params{6};
            task = params{7};
            p2 = path;
            p2 = p2(1:strfind(p2,';')-1);
            split = strfind(p2,'\');
            recNum = p2(split(end-1)+1:split(end)-1);
        end
    case 3
        recNum = varargin{1};
        task = varargin{2};
        stepNum = varargin{3};
end
if strcmp(angleOrLED,'Angle')
    fileType = 2;
elseif strcmp(angleOrLED,'LED')
    fileType = 1;
end

allData = dlmread(toeFile, '', 31, 0);  % Import data portion, keep consistent
i = 0;                                  % Between scripts
j = 1;
while i == 0   % Find frame 1 in first column
    if allData(j,1) ~= 1
        j = j + 1;
    else
        i = 1;
    end
end
data = allData(j:1:end,[1 2 4:6 10:12 13:15]); % Extract relevant data,
% column 1 is frame, column 2 is
% time(ms)
% column 4 - 6 are x,y,z , column 10 - 12 are vx,vy,vz
% column 13 - 15 ax, ay, az
clear allData i j;

data = fillgaps_alldata(data); % Fixes VZ glitches and flickers (edit to enable specific range filter)
roundIndices = RoundSelector(data); % Finds all of the rounds of the recording using a moving sum
[unclustered, roundDurationStats, roundDistanceStats] = RoundIndexer(data,roundIndices); %#ok<NASGU,*ASGLU> % Indexes each rounds for stances,
                                                                                                            % swings, and steps.

if clusterOrNot == 1  % If clustering i enabled, RoundClusterer clusters the rounds by the position of the first step
    [cl_1, cl_2] = RoundClusterer(unclustered, data);
end

for ij = 1:length(textFiles)  % This loop allows for running of multiple files at once
    analyzedFile = textFiles{ij};
    
    if clusterOrNot == 1 % If data was clustered, runs scripts for both clusters
        stepBins_1 = RoundAnalyzer(cl_1,stepNum,analyzedFile,fileType,prop,binSize); % Analyzes stepNum of each round. Partitions each step into                                                                     
        stepBins_2 = RoundAnalyzer(cl_2,stepNum,analyzedFile,fileType,prop,binSize); % binSize partitions and then interpolates prop for each bin.
        [stepBins_1, badBins1]= BinFilter(stepBins_1,binSize); % Filters rounds for bad bins and separates bad rounds from good and interpolates for
        [stepBins_2, badBins2] = BinFilter(stepBins_2,binSize); % small uncaught flickers within the file
        stepBinsStats_1 = [mean(stepBins_1(:,2:end));std(stepBins_1(:,2:end));sem(stepBins_1(:,2:end));2*sem(stepBins_1(:,2:end)); ]; % Puts together
        output(stepBins_1,badBins1,stepBinsStats_1,1,analyzedFile,recNum,stepNum,task,prop,binSize);  % all of the round stats
        stepBinsStats_2 = [mean(stepBins_2(:,2:end));std(stepBins_2(:,2:end));sem(stepBins_2(:,2:end));2*sem(stepBins_2(:,2:end)); ];
        output(stepBins_2,badBins2,stepBinsStats_2,1,analyzedFile,recNum,stepNum,task,prop,binSize);
    end
    
    if clusterOrNot == 0 % Same as above but for only one bin variable since it is unclustered.
        stepBins_1 = RoundAnalyzer(unclustered,stepNum,analyzedFile,fileType,prop,binSize); 
        [stepBins_1, badBins1] = BinFilter(stepBins_1,binSize);
        if strcmp(task,'Flat')
            stepBins_1(:,2:end) = stepBins_1(:,2:end) - flatAdjustment;
        end
        stepBinsStats_1 = [mean(stepBins_1(:,2:end));std(stepBins_1(:,2:end));sem(stepBins_1(:,2:end));2*sem(stepBins_1(:,2:end)); ];
        output(stepBins_1,badBins1,stepBinsStats_1,1,analyzedFile,recNum,stepNum,task,prop,binSize);
        stepBins_2 = zeros(1);badBins2 = zeros(1);stepBinsStats_2 = zeros(1);
    end
    
    fclose('all');
end

% nargout allows for output of results in order to compare two tasks using
% kinem_cat_2task.
switch nargout
    case 0
    case 1
        varargout{1} = stepBins_1;
    case 2
        varargout{1} = stepBins_1;varargout{2} = badBins1;
    case 3
        varargout{1} = stepBins_1;varargout{2} = badBins1;varargout{3} = stepBinsStats_1;
    case 4
        varargout{1} = stepBins_1;varargout{2} = badBins1;varargout{3} = stepBinsStats_1;
        varargout{4} = stepBins_2;
    case 5
        varargout{1} = stepBins_1;varargout{2} = badBins1;varargout{3} = stepBinsStats_1;
        varargout{4} = stepBins_2;varargout{5} = badBins2;
    case 6
        varargout{1} = stepBins_1;varargout{2} = badBins1;varargout{3} = stepBinsStats_1;
        varargout{4} = stepBins_2;varargout{5} = badBins2;varargout{6} = stepBinsStats_2;
    case 7
        varargout{1} = stepBins_1;varargout{2} = badBins1;varargout{3} = stepBinsStats_1;
        varargout{4} = stepBins_2;varargout{5} = badBins2;varargout{6} = stepBinsStats_2;
        varargout{7} = {textFiles, 1, recNum, stepNum, prop, binSize};
end
