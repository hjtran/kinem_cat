function stepBins = RoundAnalyzer(cluster, stepNum, fileName, fileType, prop, binSize)
% Based on step, stance, and swing indices found using toe file, analyzes
% given files "prop" during duration of "stepNum" of round.


allData = dlmread(fileName, '', 31, 0);  % Import data portion, 
                                     % keep consistent between scripts
i = 0;
j = 1;
while i == 0   % Finds frame 1 in first column
    if allData(j,1) ~= 1
        j = j + 1;
    else
        i = 1;
    end 
end    
if fileType == 1   % Importing LED
    data = allData(j:1:end,[1 2 4:6 10:12]); % Extract relevant data, 
                                         % column 1 is frame, 
                                         % column 2 is time(ms),
                                         % column 4 - 6 are x,y,z , 
                                         % column 10 - 12 are vx,vy,vz
    data = fillgaps(data);
                                         
else               % Importing Angle
    data = allData(j:1:end, 1:7);
    data = fillanglegaps2(data);
    
end

                                         
                                         
clear allData i j;



matCluster = cell2mat(cluster);
stepIndices = zeros(length(matCluster),2);

for i=1:length(matCluster) % Marks the steps to be analyzed. If returns an 
                            % an error, then that step will be set as [0,0]
         try
            stepIndices(i,:) = matCluster(i).StepIndices(stepNum,:);
         catch err
            if strcmp(err.identifier,'MATLAB:badsubscript')
            warning(['Round ' num2str(matCluster(i).RoundNum) ' does not have step ' num2str(stepNum)])
            stepIndices(i,:) = [0 0];
            end
         end

    
end

roundIndices = zeros(length(matCluster),2); % Marks round indices
for i=1:length(matCluster)
    roundIndices(i,:) = matCluster(i).RoundIndices(1,:);
end
roundNums = zeros(length(matCluster),1); % Marks the round number
for i=1:length(matCluster)
    roundNums(i,1) = matCluster(i).RoundNum;
end

if fileType == 1
    if strcmp(prop,'Px'), propInt = 3; end
    if strcmp(prop,'Py'), propInt = 4; end    
    if strcmp(prop,'Pz'), propInt = 5; end
    if strcmp(prop,'Vx'), propInt = 6; end
    if strcmp(prop,'Vy'), propInt = 7; end
    if strcmp(prop,'Vz'), propInt = 8; end  
    if strcmp(prop,'Ax'), propInt = 9; end 
    if strcmp(prop,'Ay'), propInt = 10; end 
    if strcmp(prop,'Az'), propInt = 11; end 
elseif fileType == 2
    if strcmp(prop,'Angle'), propInt = 3; end
    if strcmp(prop,'C.Angle'), propInt = 4; end
    if strcmp(prop,'S.Angle'), propInt = 5; end
    if strcmp(prop,'Vel'), propInt = 6; end
    if strcmp(prop,'Acc'), propInt = 7; end
end


    
stepBins = zeros(length(cluster),binSize); % Normalizes each step to be comparable
                                            % Each step is broken down into
                                            % the number of the binSize.
for roundNum=1:length(cluster)
    stepData = data(roundIndices(roundNum,1)+stepIndices(roundNum,1)-1:roundIndices(roundNum,1)+stepIndices(roundNum,2),:);
    regLine = fit(stepData(:,2)-min(stepData(:,2)),stepData(:,propInt),'smoothingspline');
    intervals = max(stepData(:,2)-min(stepData(:,2))) / (binSize-1);
    intervals = 0:intervals:max(stepData(:,2)-min(stepData(:,2)));
    stepBins(roundNum,:) = feval(regLine,intervals);
end





stepBins = [roundNums stepBins];


% Px Py Pz Vx Vy Vz Ax Ay Az 
% Angle C.Angle S.Angle Vel Acc


    
    
    
    
    
    
    
    
    %swingBinSize = 25;
    %for stepNum = 1:length(swingIndices);
    %stepData = roundData(swingIndices(stepNum,1):swingIndices(stepNum,2),:);
    %regLine = fit(stepData(:,2)-min(stepData(:,2)),stepData(:,7),'smoothingspline');
    %intervals = max(stepData(:,2)-min(stepData(:,2))) / (swingBinSize-1);
    %intervals = 0:intervals:max(stepData(:,2)-min(stepData(:,2)));
    %stepBins(end,:) = feval(regLine,intervals);
    %stepBins(end+1,:) = zeros(1,25);
    %end  