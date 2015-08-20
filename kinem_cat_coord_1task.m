function kinem_cat_coord_1task(varargin)
% Created by Joey Tran in December 2013
% For info or help, email j.tran4418@gmail.com4
% Running program without arguments will prompt for recording number
% and, task will be used from parameters. Running as function
% first argument will be recording number, second argument will be task.
% Any number of arguments will run

%Parameters ---------------------------------------------------------------
toeFile = 'Toe.txt';    % name of toe file to analyze beg. and end of steps
binSize = 20; % number of bins
clusterOrNot = 0; % 1 to cluster, 0 to not
textFiles = { 'Toe.txt' };
%End Parameters -----------------------------------------------------------


switch nargin
    case 0
        recNum = input('Recording Number? ','s');
        task = input('Task? ', 's');
    case 1
        recNum = varargin{1};
        task = input('Task? ', 's');
    case 2
        if varargin{1} == 'False'
            params = varargin{2};
            toeFile = params{1};
            textFiles = params(1);
            p2 = path;
            p2 = p2(1:strfind(p2,';')-1);
            split = strfind(p2,'\');
            recNum = p2(split(end-1)+1:split(end)-1);
            task = p2(split(end)+1:end);
        else
        recNum = varargin{1};
        task = varargin{2};
        end
        
end    

allData = dlmread(toeFile, '', 31, 0);  % Import data portion, keep consistent
% Between scripts

%Floor1 ='Floor1.txt'; %location
%if exist('Floor5.txt') == 2
%    Floor2 ='Floor5.txt';
%elseif exist('Floor4.txt') == 2
%    Floor2 = 'Floor4.txt';
%elseif exist('Floor3.txt') == 2
%    Floor2 = 'Floor3.txt';
%elseif exist('Floor2.txt') == 2
%    Floor2 = 'Floor2.txt';
%else
%    error('No second floor text!\n');
%end

Floor1 ='Reference_Rung3.txt'; %location
if exist('Reference_Rung8.txt') == 2
    Floor2 ='Reference_Rung8.txt';
elseif exist('Reference_Rung9.txt') == 2
    Floor2 = 'Reference_Rung9.txt';
elseif exist('Reference_Rung5.txt') == 2
    Floor2 = 'Reference_Rung5.txt';
elseif exist('Reference_Rung10.txt') == 2
    Floor2 = 'Reference_Rung10.txt';
else
    error('No second floor text!\n');
end

i = 0;
j = 1;
while i == 0   % Find frame 1 in first column
    if allData(j,1) ~= 1
        j = j + 1;
    else
        i = 1;
    end
end
Pymm = allData(:,5);
Pzmm = allData(:,6);
Floor1 = dlmread(Floor1,'',4000,0);
Floor1 = [Floor1(1:50,5) Floor1(1:50,6)]; %Storing 50 values from Floor 1 LEDs
Floor2 = dlmread(Floor2,'',4000,0);
Floor2 = [Floor2(1:50,5) Floor2(1:50,6)]; %Storing 50 values from Floor 5 LEDs
Floor1 = Floor1(Floor1(:,1) ~= 0 & Floor2(:,1) ~= 0,:);
Floor2 = Floor2(Floor1(:,1) ~= 0 & Floor2(:,1) ~= 0,:);
mean_Floor1=[mean(Floor1(:,1)), mean(Floor1(:,2))];
mean_Floor5=[mean(Floor2(:,1)), mean(Floor2(:,2))];
slope=((mean_Floor5(2)-mean_Floor1(2))/(mean_Floor5(1)-mean_Floor1(1)));
b=(mean_Floor5(2)-slope*mean_Floor5(1))+10;
Pzmm=(Pzmm-(slope*Pymm+b));

allData(:,6) = Pzmm;
allData(:,5) = Pymm;

data = allData(j:1:end,[1 2 4:6 10:12]); % Extract relevant data,
% column 1 is frame, column 2 is
% time(ms)
% column 4 - 6 are x,y,z , column 10 - 12 are vx,vy,vz

clear allData i j;

data = fillgaps(data);

roundIndices = RoundSelector(data);

[unclustered, roundDurationStats, roundDistanceStats] = RoundIndexer(data,roundIndices); %#ok<*NASGU,*ASGLU>

if clusterOrNot == 1
    [cl_1, cl_2] = RoundClusterer(unclustered, data);
end




for ij = 1:length(textFiles)  % This loop allows for running of multiple files at once
    analyzedFile = textFiles{ij};

    
    if clusterOrNot == 1
        coords_1 = CoordExtractor(cl_1,analyzedFile,binSize);
        coords_2 = CoordExtractor(cl_2,analyzedFile,binSize);
        output_coords(coords_1,1,analyzedFile,recNum,task);
        output_coords(coords_2,2,analyzedFile,recNum,task);
    end
    
    if clusterOrNot == 0
        unclusteredCoords = CoordExtractor(unclustered,analyzedFile,binSize);
        i = 0;
        output_coords(unclusteredCoords,2,analyzedFile,recNum,task,roundDurationStats);
        
    end

fclose('all');
end

