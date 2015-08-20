function [unclustered, roundDurationStats, roundDistanceStats] = RoundIndexer(data,roundIndices)
% Indexes each individual round for the start and end index of
% each step, stance, and swing.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stancePartition = 30;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

roundDurationStats = zeros(length(roundIndices),7);
roundDistanceStats = zeros(length(roundIndices),6);
for roundNum = 1:length(roundIndices)       % Begin round analysis
    roundData = data(roundIndices(roundNum,1):roundIndices(roundNum,2),:); %Extract roundData
    
    vyMoveAvg = zeros(length(roundData) - 2,1);  %Calculate MoveAvg(size 3) vector for vy to find stances
    for i = 1:length(roundData) - 2
        vyMoveAvg(i,1) = sum(roundData(i:i+2,7)) / 3 ;
    end
    
    %figure;
    %plot(vyMoveAvg);
    
    
    j = 1;
    i = 1;
    
    while i <= length(vyMoveAvg) - 1 % Find beginning and end of stances
        if (vyMoveAvg(i) >= stancePartition || vyMoveAvg(i) <= -40 )&& i < length(vyMoveAvg)
            i = i + 1;
        else
            stanceIndices(j,1) = i + 1; 
            while vyMoveAvg(i) < stancePartition && vyMoveAvg(i) > -40 && i < length(vyMoveAvg)
                i = i + 1;
            end
            if i == length(vyMoveAvg)-1
                stanceIndices(j,:) = []; %#ok<*AGROW>
                break;
            end
            stanceIndices(j,2) = i + 1;
            j = j + 1;
        end
    end
    clear i j;
    if ~exist('stanceIndices','var')
        stanceIndices = ones(1,2);
    end
    
    stancesToRemove = stanceIndices(:,2) - stanceIndices(:,1);
    toKeep = stancesToRemove > 20;
    stanceIndices = stanceIndices(toKeep,:);
    clear toKeep stancesToRemove;

    
    %stanceIndices = reshape(stanceIndices(stanceIndices<=length(vyMoveAvg)),length(stanceIndices(stanceIndices<=length(vyMoveAvg)))/2,2);
    
    swingIndices = zeros(length(stanceIndices)-1,2);
    stepIndices = zeros(length(stanceIndices)-1,2);
    
    for i = 1:size(stanceIndices,1) - 1 % Find beginning and end of swing
        swingIndices(i,1) = stanceIndices(i,2);
        swingIndices(i,2) = stanceIndices(i+1,1);
    end
    if size(swingIndices,1) == 0
        swingIndices = ones(1,2);
    end
    if exist('swingIndices') == 1
        if swingIndices(1,1) == 0 && swingIndices(1,2) == 0
            swingIndices = ones(1,2);
        end
    end
    
    for i = 1:size(stanceIndices,1) - 1 % Mark beginning and end of steps
        if i ~= size(stanceIndices,1) - 1
            stepIndices(i,1) = swingIndices(i,1); %#ok<*SAGROW>
            stepIndices(i,2) = swingIndices(i+1,1);
        else
            stepIndices(i,1) = swingIndices(i,1);
            stepIndices(i,2) = stanceIndices(i+1,2);
        end
        
    end
    if stepIndices(1,1) == 0 && stepIndices(1,2) == 0;
        stepIndices = ones(1,2);
    end
    
    % Average Swing Analyzer
    %swingBinSize = 25;
    %for stepNum = 1:length(swingIndices);
    %stepData = roundData(swingIndices(stepNum,1):swingIndices(stepNum,2),:);
    %regLine = fit(stepData(:,2)-min(stepData(:,2)),stepData(:,7),'smoothingspline');
    %intervals = max(stepData(:,2)-min(stepData(:,2))) / (swingBinSize-1);
    %intervals = 0:intervals:max(stepData(:,2)-min(stepData(:,2)));
    %stepBins(end,:) = feval(regLine,intervals);
    %stepBins(end+1,:) = zeros(1,25);
    %end
    
    %
    % Duration
    %stanceIndices(1,:) = [];
    stanceDuration = roundData(stanceIndices(2:end,2),2) - roundData(stanceIndices(2:end,1),2);
    swingDuration = roundData(swingIndices(:,2),2) - roundData(swingIndices(:,1),2);
    stepDuration = roundData(stepIndices(:,2),2) - roundData(stepIndices(:,1),2);
    meanStance = mean(stanceDuration);
    meanSwing = mean(swingDuration);
    meanStep = mean(stepDuration);
    dutyFactor = meanStance / meanStep;
    stdStance = std(stanceDuration);
    stdSwing = std(swingDuration);
    stdStep = std(stepDuration);
    
    roundDurationStats(roundNum,1:7) = [meanStance stdStance meanSwing stdSwing meanStep stdStep dutyFactor];
    
    %
    % Distance
    stanceDistance = roundData(stanceIndices(2:end,2),4) - roundData(stanceIndices(2:end,1),4);
    swingDistance = roundData(swingIndices(:,2),4) - roundData(swingIndices(:,1),4);
    stepDistance = roundData(stepIndices(:,2),4) - roundData(stepIndices(:,1),4);
    meanStance = mean(stanceDistance);
    meanSwing = mean(swingDistance);
    meanStep = mean(stepDistance);
    stdStance = std(stanceDistance);
    stdSwing = std(swingDistance);
    stdStep = std(stepDistance);
    
    roundDistanceStats(roundNum,1:6) = [meanStance stdStance meanSwing stdSwing meanStep stdStep];
    unclustered{roundNum} = struct('RoundNum',roundNum, ...
        'RoundIndices',roundIndices(roundNum,:), ...
        'StepIndices',stepIndices, ...
        'StanceIndices',stanceIndices);
    [numSteps,~] = size(stepIndices);
    if numSteps >= 7 || numSteps < 3
        warning(['Round ' num2str(roundNum) ' has ' num2str(numSteps) ' steps.'])
    end
    clear stanceIndices vyMoveAvg swingIndices stepIndices numSteps;
end
roundDurationStats(length(roundIndices)+1,1:7) = mean(roundDurationStats);
roundDurationStats(length(roundIndices)+2,1:7) = std(roundDurationStats);


%roundMeanStance = mean(roundStats(:,1));
%roundStdStance = sqrt(sum(power(roundStats(:,2),2)));
%roundMeanSwing = mean(roundStats(:,3));
%roundStdSwing = sqrt(sum(power(roundStats(:,4),2)));
%roundMeanStep = mean(roundStats(:,5));
%roundStdStep = sqrt(sum(power(roundStats(:,6),2)));
        
        
        
        
        
