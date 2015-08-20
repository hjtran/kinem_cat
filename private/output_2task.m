function output_2task(stepBins,badBins,stepBinsStats,taskStepBins,taskBadBins,taskStepBinsStats,params,task1,task2)
% Outputs data into kinemresults file
clustNum = params{2};fileName = params{1}; recNum = params{3}; stepNum = params{4}; prop = params{5}; binSize = params{6};fileName = fileName{1};
fileres = 'kinemresults_2tasks.txt';
[fid2,mes] = fopen(fileres,'at');
[mes1,numerror]=ferror(fid2);
if numerror==-1
    disp( sprintf('Could not open new file <<%s>> \n',fileres ));
    disp(mes1);
else
    disp( sprintf('File <<%s>> was opened \n',fileres));
end
% Check for existence
fseek(fid2,0,'eof');
pos2=ftell(fid2);
if pos2 ~= 0
    titlefid2=0;
else
    titlefid2=1;
    disp( sprintf('New file <<%s>> has been created \n',fileres));
end
if titlefid2==1
    fprintf(fid2,'File Name,Task,Recording Number,Cluster Number,Step Number,Property,Round Number,');
    for i=1:binSize, fprintf(fid2,'%d,',i); end
    fprintf(fid2,',Task,RoundNumber,');
    for i=1:binSize, fprintf(fid2,'%d,',i); end
    fprintf(fid2,'\n\n');
end

fprintf(fid2,fileName);
fprintf(fid2,',%s,%s,%d,%d,%s,,,,,,,,,,,,,,,,,,,,,,,%s\n',task1,recNum,clustNum,stepNum,prop,task2);

len1 = (size(stepBins,1)+size(badBins,1)+size(stepBinsStats,1));
len2 = (size(taskStepBins,1)+size(taskBadBins,1)+size(taskStepBinsStats,1));
for i=1:max(len1,len2)
    if i ~= size(stepBins,1)+1 || size(badBins,1) == 0
        fprintf(fid2,',,,,,,');
    elseif i == size(stepBins,1)+1 && size(badBins,1) ~= 0
        fprintf(fid2,',,,,,Bad Rounds,');
    end
    % Control Output
    if i <= size(stepBins,1)
        for j=1:binSize+1
            fprintf(fid2, '%.4f,',stepBins(i,j));
        end
    end
    if i > size(stepBins,1)&& i <= size(stepBins,1)+size(badBins,1)
        for j=1:binSize+1
            fprintf(fid2, '%.4f,',badBins(i-size(stepBins,1),j));
        end
    end
    if i > size(stepBins,1)+size(badBins,1) && i <= size(stepBins,1)+size(badBins,1)+size(stepBinsStats,1)
        if i-(size(stepBins,1)+size(badBins,1)) == 1
            fprintf(fid2,'AVG,');
        end
        if i-(size(stepBins,1)+size(badBins,1)) == 2
            fprintf(fid2,'STDEV,');
        end
        if i-(size(stepBins,1)+size(badBins,1)) == 3
            fprintf(fid2,'SEM,');
        end
        if i-(size(stepBins,1)+size(badBins,1)) == 4
            fprintf(fid2,'SEMx2,');
        end
        if i-(size(stepBins,1)+size(badBins,1)) == 5
            fprintf(fid2,'TTest P,');
        end
        for j=1:binSize
            fprintf(fid2, '%.4f,',stepBinsStats(i-(size(stepBins,1)+size(badBins,1)),j));
        end
    end
    if i > size(stepBins,1)+size(badBins,1)+size(stepBinsStats,1)
        fprintf(fid2, ',,,,,,,,,,,,,,,,,,,,,');
    end
    
    
    % Task Output
    if (i ~= size(taskStepBins,1)+1) || (size(taskBadBins,1) == 0)
        fprintf(fid2,',,');
    elseif i == (size(taskStepBins,1)+1) && (size(taskBadBins,1) ~= 0)
        fprintf(fid2,',Bad Rounds,');
    end
    
    if i <= size(taskStepBins,1)
        for j=1:binSize+1
            fprintf(fid2, '%.4f,',taskStepBins(i,j));
        end
    end
    if i > size(taskStepBins,1)&& i <= size(taskStepBins,1)+size(taskBadBins,1)
        for j=1:binSize+1
            fprintf(fid2, '%.4f,',taskBadBins(i-size(taskStepBins,1),j));
        end
    end
    if i > size(taskStepBins,1)+size(taskBadBins,1) && i <= size(taskStepBins,1)+size(taskBadBins,1)+size(taskStepBinsStats,1)
        if i-(size(taskStepBins,1)+size(taskBadBins,1)) == 1
            fprintf(fid2,'AVG,');
        end
        if i-(size(taskStepBins,1)+size(taskBadBins,1)) == 2
            fprintf(fid2,'STDEV,');
        end
        if i-(size(taskStepBins,1)+size(taskBadBins,1)) == 3
            fprintf(fid2,'SEM,');
        end
        if i-(size(taskStepBins,1)+size(taskBadBins,1)) == 4
            fprintf(fid2,'SEMx2,');
        end
        if i-(size(taskStepBins,1)+size(taskBadBins,1)) == 5
            fprintf(fid2,'TTest P,');
        end
        for j=1:binSize
            fprintf(fid2, '%.4f,',taskStepBinsStats(i-(size(taskStepBins,1)+size(taskBadBins,1)),j));
        end
    end
    if i > size(taskStepBins,1)+size(taskBadBins,1)+size(taskStepBinsStats,1)
    end
    fprintf(fid2,'\n');
end
fprintf(fid2,'\n\n');
fclose('all');

      