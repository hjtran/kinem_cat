function fileDir = multiple_file_runner(varargin)
% multiple_file_runner(programType,task(task1),task2)
% Runs multiple files through any of the kinem_cats'
skipDir = 0;
switch nargin
    case 0
        programType = input('Which kinem_cat would you like to run?\n 1 - kinem_cat_1task\n 2 - kinem_cat_2task\n 3 - kinem_cat_coord_1task\n 4 - kinem_cat_coord_2task\n');
        switch programType
            case 1
                task = input('What is the task? (Flat, Rocks, etc)\n','s');
            case 2
                task1 = input('What is task 1? (Flat, Rocks, etc)\n','s');
                task2 = input('What is task 2? (Flat, Rocks, etc)\n','s');
            case 3
                task = input('What is the task? (Flat, Rocks, etc)\n','s');
            case 4
                task1 = input('What is task 1? (Flat, Rocks, etc)\n','s');
                task2 = input('What is task 2? (Flat, Rocks, etc)\n','s');
        end
        
    case 1
        switch programType
            case 1
                task = input('What is the task? (Flat, Rocks, etc)\n','s');
            case 2
                task1 = input('What is task 1? (Flat, Rocks, etc)\n','s');
                task2 = input('What is task 2? (Flat, Rocks, etc)\n','s');
            case 3
                task = input('What is the task? (Flat, Rocks, etc)\n','s');
            case 4
                task1 = input('What is task 1? (Flat, Rocks, etc)\n','s');
                task2 = input('What is task 2? (Flat, Rocks, etc)\n','s');
        end
    case 2
        programType = varargin{1};
        task = varargin{2};
    case 3
        programType = varargin{1};
        task1 = varargin{2};
        task2 = varargin{3};
    case 4
        programType = varargin{1};
        params = varargin{4};
        if length(params) > 6
            task1 = params{7}(1:strfind(params{7},'&')-1);
            task2 = params{7}(strfind(params{7},'&')+1:end);
            if size(strfind(params{7},'&'))==0
                task = params{7};
            end
        else
            task1 = params{2}(1:strfind(params{2},'&')-1);
            task2 = params{2}(strfind(params{2},'&')+1:end);
            if size(strfind(params{2},'&'))==0
                task = params{2};
            end
        end
    case 5
                programType = varargin{1};
        params = varargin{4};
        if length(params) > 6
            task1 = params{7}(1:strfind(params{7},'&')-1);
            task2 = params{7}(strfind(params{7},'&')+1:end);
            if size(strfind(params{7},'&'))==0
                task = params{7};
            end
        else
            task1 = params{2}(1:strfind(params{2},'&')-1);
            task2 = params{2}(strfind(params{2},'&')+1:end);
            if size(strfind(params{2},'&'))==0
                task = params{2};
            end
        end
        skipDir = 1;
        fileDir = varargin{5};
end

if ~skipDir
    fileDir = uigetdir;
end
switch programType
    case 1 % kinem_cat_1task
        p = path;
        fileDir = [fileDir '\'];
        userpath(fileDir);
        p1 = userpath;
        p1(end) = [];
        list = dir(p1);
        list = struct2cell(list);
        fileNames = list(1,:);
        isDir = cell2mat(list(4,:));
        fileNames = fileNames(isDir);
        fileNames(1:2) = [];
        for i = 1:length(fileNames)
            disp([fileNames{i} ' is being processed'])
%            listFol = dir([p1 fileNames{i}]);  % Capitalize first letter of task folders
%            listFol(1:2) = [];
%            for j=1:length(listFol)
%                transname = [p1 fileNames{i} '\' listFol(j).name 't']; 
%                movefile([p1 fileNames{i} '\' listFol(j).name],transname);
%                movefile(transname,[p1 fileNames{i} '\' upper(listFol(j).name(1)) lower(listFol(j).name(2:end))]);
%            end
            path([p1 fileNames{i} '\' task],p);
            if nargin < 4
                kinem_cat_1task(fileNames{i},task);
            elseif nargin >= 4
                kinem_cat_1task('False',params);
            end      
            path(p)
        end
        path(p);
    case 2 % kinem_cat_2task
        p = path;
        fileDir = [fileDir '\'];
        userpath(fileDir);
        p1 = userpath;
        p1(end) = [];
        stepNum = 3;
        list = dir(p1);
        list = struct2cell(list);
        fileNames = list(1,:);
        isDir = cell2mat(list(4,:));
        fileNames = fileNames(isDir);
        fileNames(1:2) = [];
        for i=1:length(fileNames)
            userpath([p1 fileNames{i}]);
            if nargin >= 4
                kinem_cat_2task(stepNum,task1,task2,params);
            else
                kinem_cat_2task(stepNum,task1,task2);
            end
            path(p);
        end
        
        path(p)
    case 3 % kinem_cat_coords_1task
        p = path;
        fileDir = [fileDir '\'];
        userpath(fileDir);
        p1 = userpath;
        p1(end) = [];
        list = dir(p1);
        list = struct2cell(list);
        fileNames = list(1,:);
        isDir = cell2mat(list(4,:));
        fileNames = fileNames(isDir);
        fileNames(1:2) = [];
        for i = 1:length(fileNames)
            disp([fileNames{i} ' is being processed'])
            path([p1 fileNames{i} '\' task],p);
            kinem_cat_coord_1task('False',params);
            path(p)
        end
    case 4 % kinem_cat_coords_2task
        p = path;
        fileDir = [fileDir '\'];
        userpath(fileDir);
        p1 = userpath;
        p1(end) = [];
        list = dir(p1);
        list = struct2cell(list);
        fileNames = list(1,:);
        isDir = cell2mat(list(4,:));
        fileNames = fileNames(isDir);
        fileNames(1:2) = [];
        for i = 1:length(fileNames)
            disp([fileNames{i} ' is being processed'])
            path([p1 fileNames{i} '\' task1],p);
            kinem_cat_coord_1task('False',params);
            path(p)
            path([p1 fileNames{i} '\' task2],p);
            kinem_cat_coord_1task('False',params);
        end
end