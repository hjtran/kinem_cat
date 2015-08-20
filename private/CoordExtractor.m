function coordsAndStrides = CoordExtractor(cluster, fileName, binSize)
% Finds coordinates of each step
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stepLim = 6;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

allData = dlmread(fileName, '', 31, 0);  % Import data portion, keep consistent
% Between scripts
Floor1 ='Floor1.txt'; %location
if exist('Floor5.txt') == 2
    Floor2 ='Floor5.txt';
elseif exist('Floor4.txt') == 2
    Floor2 = 'Floor4.txt';
elseif exist('Floor3.txt') == 2
    Floor2 = 'Floor3.txt';
elseif exist('Floor2.txt') == 2
    Floor2 = 'Floor2.txt';
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
goodFrames = Floor1(:,1) ~= 0 & Floor2(:,1) ~= 0;
Floor1 = Floor1(goodFrames,:);
Floor2 = Floor2(goodFrames,:);
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



matCluster = cell2mat(cluster);
stanceIndices = cell(length(cluster),1);

for i=1:length(matCluster)
            stanceIndices{i} = matCluster(i).StanceIndices(:,:);
end

roundIndices = zeros(length(matCluster),2);
for i=1:length(matCluster)
    roundIndices(i,:) = matCluster(i).RoundIndices(1,:);
end
roundNums = zeros(length(matCluster),1);
for i=1:length(matCluster)
    roundNums(i,1) = matCluster(i).RoundNum;
end


%stepBins = zeros(length(cluster),binSize);
stepCoords = zeros(length(cluster),12);
for roundNum=1:length(cluster)
    if length(stanceIndices{roundNum}) > stepLim
        totStep = stepLim;
    else
        totStep = length(stanceIndices{roundNum});
    end
    for stepNum=1:totStep
        for i = 1:2
            stepData = data(roundIndices(roundNum,1)+stanceIndices{roundNum}(stepNum,1)+5,3+i);
            %            regLine = fit(stepData(:,2)-min(stepData(:,2)),stepData(:,axesColumns(i)),'smoothingspline');
            %            intervals = max(stepData(:,2)-min(stepData(:,2))) / (binSize-1);
            %            intervals = 0:intervals:max(stepData(:,2)-min(stepData(:,2)));
            %            stepBins = feval(regLine,intervals);
            stepCoords(roundNum,(stepNum*2)+i-2) = stepData;
        end
    end
end


stepStrides = zeros(roundNum,10);
for i=1:10
    stepStrides(:,i) = stepCoords(:,i+2) - stepCoords(:,i);
end
for i = 1:5
    overallStrides(:,i) = sqrt(stepStrides(:,(i*2)-1).^2+stepStrides(:,(i*2)).^2);
end


coordsAndStrides = [roundNums, stepCoords, stepStrides overallStrides];
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