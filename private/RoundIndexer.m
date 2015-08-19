function [unclustered, roundDurationStats, roundDistanceStats] = RoundIndexer(data,roundIndices)
% Indexes each individual round for the start and end index of 
% each step, stance, and swing.
% TO DO LIST:
% Add filter parameters to take out bad steps:
roundDurationStats = zeros(length(roundIndices),7); % Preallocate memory
roundDistanceStats = zeros(length(roundIndices),6);
for roundNum = 1:length(roundIndices)       % The number of rounds is based on the indices found in RoundSelector
    roundData = data(roundIndices(roundNum,1):roundIndices(roundNum,2),:); 
                                                    % The roundData is
                                                    % based on the data
                                                    % from the beginning to
                                                    % the end of a round.
                                                    % Extracts this data.
    
    vyMoveAvg = zeros(length(roundData) - 2,1);  % Calculates MoveAvg(size 3) vector for vy to find stances
    for i = 1:length(roundData) - 2
        vyMoveAvg(i,1) = sum(roundData(i:i+2,7)) / 3 ;
    end
    
    %figure;
    %plot(vyMoveAvg);
    
    
    j = 1;
    i = 1;
    
    while i <= length(vyMoveAvg) - 1 % Finds beginning and end of stances.
                                    % This searches all rounds for the indices in
                                    % which the velocity on the y-axis is
                                    % zero or nonzero. 
        if (vyMoveAvg(i) >= 13 || vyMoveAvg(i) <= -30 )&& i < length(vyMoveAvg)
            i = i + 1;
        else
            stanceIndices(j,1) = i + 1;
            while vyMoveAvg(i) < 13 && vyMoveAvg(i) > -30 && i < length(vyMoveAvg)
                i = i + 1;
            end
            if i == length(vyMoveAvg)-1
                stanceIndices(j,:) = [];
                break;
            end
            stanceIndices(j,2) = i + 1;
            j = j + 1;
        end
    end
    clear i j;
    
    stancesToRemove = stanceIndices(:,2) - stanceIndices(:,1); % Removes stances that may be too long
    toKeep = stancesToRemove > 20;
    stanceIndices = stanceIndices(toKeep,:);
    
    
    %stanceIndices = reshape(stanceIndices(stanceIndices<=length(vyMoveAvg)),length(stanceIndices(stanceIndices<=length(vyMoveAvg)))/2,2);
    
    swingIndices = zeros(length(stanceIndices)-1,2); % Preallocate memory
    stepIndices = zeros(length(stanceIndices)-1,2);
    
    for i = 1:size(stanceIndices,1) - 1 % Finds beginning and end of swing 
                                        % based on the beginning and end of
                                        % stance
        swingIndices(i,1) = stanceIndices(i,2);
        swingIndices(i,2) = stanceIndices(i+1,1);
    end
    
    for i = 1:size(stanceIndices,1) - 1 % Marks beginning and end of steps
                                        % based on the beginning of swing
                                        % and end of stance
        if i ~= size(stanceIndices,1) - 1
        stepIndices(i,1) = swingIndices(i,1); %#ok<*SAGROW>
        stepIndices(i,2) = swingIndices(i+1,1);
        else
        stepIndices(i,1) = swingIndices(i,1);
        stepIndices(i,2) = stanceIndices(i+1,2);
        end
        
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
                               'StanceIndices',stanceIndices); % Marks the properties of unclustered data
    numSteps = size(stepIndices,1); % Sets up number of steps for RoundAnalyzer
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
        
        
        
        
        
