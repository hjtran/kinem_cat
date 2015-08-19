function coordsAndStrides = CoordExtractor(cluster, fileName, binSize)
% Finds coordinates of each step


allData = dlmread(fileName, '', 31, 0);  % Imports data portion, 
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
    data = allData(j:1:end,[1 2 4:6 10:12]); % Extracts relevant data, 
                                         % column 1 is frame,
                                         % column 2 is time(ms),
                                         % column 4 - 6 are x,y,z , 
                                         % column 10 - 12 are vx,vy,vz
    data = fillgaps(data);
                                         
                                         
                                         
clear allData i j;



matCluster = cell2mat(cluster);
stanceIndices = cell(length(cluster),1); 

for i=1:length(matCluster) % Marks the indices of beginning and end of stance
            stanceIndices{i} = matCluster(i).StanceIndices(:,:);
end

roundIndices = zeros(length(matCluster),2); % Marks the beginning and end of rounds
for i=1:length(matCluster)
    roundIndices(i,:) = matCluster(i).RoundIndices(1,:);
end
roundNums = zeros(length(matCluster),1); % Marks the round number
for i=1:length(matCluster)
    roundNums(i,1) = matCluster(i).RoundNum;
end

axesColumns = [4 5]; % finds the position of the stance on the y, z coordinate plane
%stepBins = zeros(length(cluster),binSize);
stepCoords = zeros(length(cluster),12);
for roundNum=1:length(cluster)
    if length(stanceIndices{roundNum}) > 6
    stepLim = 6;
    else
    stepLim = length(stanceIndices{roundNum});
    end
    for stepNum=1:stepLim
        for i = 1:2
            stepData = data(roundIndices(roundNum,1)+stanceIndices{roundNum}(stepNum,1),3+i);
%            regLine = fit(stepData(:,2)-min(stepData(:,2)),stepData(:,axesColumns(i)),'smoothingspline');
%            intervals = max(stepData(:,2)-min(stepData(:,2))) / (binSize-1);
%            intervals = 0:intervals:max(stepData(:,2)-min(stepData(:,2)));
%            stepBins = feval(regLine,intervals);
            stepCoords(roundNum,(stepNum*2)+i-2) = stepData;
        end
    end
end


stepStrides = zeros(roundNum,10); % Finds the length of each stride based on position od stance
for i=1:10
    stepStrides(:,i) = stepCoords(:,i+2) - stepCoords(:,i);
end



coordsAndStrides = [roundNums, stepCoords, stepStrides];
coordsAndStrides(size(coordsAndStrides,1)+1,:) = [0, mean(coordsAndStrides(:,2:end))];
coordsAndStrides(size(coordsAndStrides,1)+1,:) = [0, std(coordsAndStrides(:,2:end))];




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