function kinem_cat_coord(varargin)
% Created by Joey Tran in December 2013
% For info or help, email j.tran4418@gmail.com
% Main program: Version 1.08 Updated 4/17/2014
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


switch nargin % Function can use up to three arguments
                % no arguments will prompt for recording number and task
                % first argument will be set as the recording number
                % second will be task
                % the third will override the step number from the
                % parameters
    case 0
        recNum = input('Recording Number? ','s');
        task = input('Task? ', 's');
    case 1
        recNum = varargin{1};
        task = input('Task? ', 's');
    case 2
        recNum = varargin{1};
        task = varargin{2};
end    

allData = dlmread(toeFile, '', 31, 0);  % Import data portion, 
                                     % keep consistent between scripts
i = 0;
j = 1;
while i == 0   % Find frame 1 in first column
                % Checks each row until it's 1
                % Marks the index as j
    if allData(j,1) ~= 1
        j = j + 1;
    else
        i = 1;
    end 
end    
data = allData(j:1:end,[1 2 4:6 10:12 13:15]); % Extract relevant data, 
                                         % column 1 is frame, 
                                         % column 2 is time(ms)
                                         % column 4 - 6 are x,y,z , 
                                         % column 10 - 12 are vx,vy,vz,
                                         % column 13 - 15 ax, ay, az
                                                                           
                                         
clear allData i j;

data = fillgaps(data); % Fills gaps for P, V, A, for vz glitches (flickers, etc)

roundIndices = RoundSelector(data); % Separates VZ file into rounds that the
                                    % user could choose to use or not

[unclustered, roundDurationStats, roundDistanceStats] = RoundIndexer(data,roundIndices); 
        %#ok<*NASGU,*ASGLU>
        % Indexes each individual round for the start and end index of each 
        % step, stance, and swing

if clusterOrNot == 1 % If user chooses to cluster,
                % Clusters each round based on placement of first step
    [cl_1, cl_2] = RoundClusterer(unclustered, data);
end




for ij = 1:length(textFiles)  % This loop allows for running of multiple files at once
    analyzedFile = textFiles{ij};

    
    if clusterOrNot == 1
        coords_1 = CoordExtractor(cl_1,analyzedFile,binSize); % CoordExtracter finds the coordinates
                                                                % of each
                                                                % step and
                                                                % determines
                                                                % the
                                                                % length of
                                                                % each
                                                                % stride
                                                               
        coords_2 = CoordExtractor(cl_2,analyzedFile,binSize);
        output_coords(coords_1,1,analyzedFile,recNum,task); % Outputs coordinate data into kinemresults file
        output_coords(coords_2,2,analyzedFile,recNum,task); 
    end

    if clusterOrNot == 0
        unclusteredCoords = CoordExtractor(unclustered,analyzedFile,binSize);
        output_coords(unclusteredCoords,2,analyzedFile,recNum,task,roundDurationStats); % Outputs coordinate data into kinemresults file
    end

fclose('all');
end

