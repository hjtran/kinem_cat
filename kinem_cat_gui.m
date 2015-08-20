% Main script to run graphical user interface of kinem_cat





i = main_gui;
userpath('reset');
path(pathdef);
if i==1
    params = bin_params_gui;
    % params = { toeText, angleOrLED, binSize, stepNum, Analysis File,
    % Property, tasks, numTasks, oneFile } size = 9;
    split = strfind(params{5},',');
    if isempty(split)
        files = cell(1,1);
        files{1} = [params{5} '.txt'];
    elseif length(split) == 1
        files = cell(2,1);
        files{1} = [params{5}(1:split(1)-1) '.txt'];
        files{2} = [params{5}(split(1)+1:end) '.txt'];
    elseif length(split) > 1
        files = cell(length(split)+1,1);
        files{1} = [params{5}(1:split(1)-1) '.txt'];
        for i=1:length(split)-1
            files{i+1} = [params{5}(split(i)+1:split(i+1)-1) '.txt'];
        end
        files{end} = [params{5}(split(end)+1:end) '.txt'];
    end
    for i = 1:length(files)
        params(5) = files(i);
        if params{9} && params{8} == 1 % One File One Task
            p = path;
            if i == 1
                disp('Please select the folder holding the task folder');
                fileDir = uigetdir;
                fileDir = [fileDir '\' params{7}];
            end
            userpath(fileDir);
            kinem_cat_1task('False',params);
            path(p);
        elseif params{9} && params{8} == 2 % One File Two Tasks
            p = path;
            if i == 1
                disp('Please select the folder holding the task folders');
                fileDir = uigetdir;
                fileDir = [fileDir '\'];
            end
            userpath(fileDir);
            p2 = path;
            p2 = p2(1:strfind(p2,';')-1);
            split = strfind(p2,'\');
            fileName = p2(split(end-1)+1:split(end)-1);
            task1 = params{7}(1:strfind(params{7},'&')-1);
            task2 = params{7}(strfind(params{7},'&')+1:end);
            kinem_cat_2task(params{4},task1,task2,params);
        elseif ~params{9} && params{8} == 1 % Multiple Files One Task
            if i == 1
                disp('Please select the folder holding all recording folders');
                fileDir = multiple_file_runner(1,'null','null',params);
            else
                multiple_file_runner(1,'null','null',params,fileDir);
            end
        elseif ~params{9} && params{8} == 2 % Multiple Files Two Tasks
            if i == 1
                disp('Please select the folder holding all recording folders');
                split = strfind(params{7},'&');
                task1 = params{7}(1:split-1);
                task2 = params{7}(split+1:end);
                fileDir = multiple_file_runner(2,'null','null',params);
            else
                split = strfind(params{7},'&');
                task1 = params{7}(1:split-1);
                task2 = params{7}(split+1:end);
                multiple_file_runner(2,'null','null',params,fileDir);
            end
        end
    end
    
elseif i == 2
    params = coord_params_gui;
    % params = { toeText, tasks, numTasks, oneFile }
    if params{4} == 1 && params{3} == 1 % One File One Task
        p = path;
        disp('Please select the folder holding the task folders');
        fileDir = uigetdir;
        fileDir = [fileDir '\' params{2}];
        userpath(fileDir);
        kinem_cat_coord_1task('False',params);
        path(p);
    elseif params{4} == 1 && params{3} == 2 % One File Two Tasks
        task1 = params{2}(1:strfind(params{2},'&')-1);
        task2 = params{2}(strfind(params{2},'&')+1:end);
        p = path;
        disp('Please select the folder holding the task folders');
        fileDir = uigetdir;
        fileDir = [fileDir '\'];
        userpath(fileDir);
        p1 = userpath;
        p1(end) = [];
        userpath([p1 task1]);
        kinem_cat_coord_1task('False',params);
        path(p);
        userpath([p1 task2]);
        kinem_cat_coord_1task('False',params);
        path(p);
    elseif params{4} == 0 && params{3} == 1 % Multiple Files One Task
        disp('Please select the folder holding all recording folders');
        multiple_file_runner(3,'null','null',params);
    elseif params{4} == 0 && params{3} == 2 % Multiple Files Two Tasks
        disp('Please select the folder holding all recording folders');
        multiple_file_runner(4,'null','null',params);
    end
end

