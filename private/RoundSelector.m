function roundIndices = RoundSelector(data)
% Separates VZ file into rounds

movSum = zeros(length(data)-100,1); % Preallocate memory for movSum
for i = 1:length(data)-100    % Create a movSum(size 100) vector to distinguish rounds
    movSum(i) = sum(data(i:i+100,3));
end

i = 150;
j = 1;
roundIndices = zeros(1,1);
while i ~= length(movSum)    % Check each movSum value, if zero than it's in between rounds
    % After beginning of round is found, checks
    % until movSum = 0 again, denoting end of
    % round. Mark both indices in roundIndices
    if movSum(i) == 0
        i = i + 1;
    else
        roundIndices(j,1) = i+100;
        while movSum(i) ~= 0
            i = i + 1;
        end
        roundIndices(j,2) = i-1;
        j = j + 1;
    end
end
clear i j;


roundsToRemove = roundIndices(:,2) - roundIndices(:,1);
toKeep = roundsToRemove > 350;
roundIndices = roundIndices(toKeep,:);

disp( [ num2str(length(roundIndices)) ' rounds found' ] );

%roundsToDelete = str2num(input(['What rounds would you like to delete? \n(Input numbers ' ...
% 'separated by commas, RETURN if deleting none)'], 's')); %#ok<ST2NM>
%roundIndices(roundsToDelete,:) = []; % deletes selected rounds

%if isempty(input('Remove outlier rounds? (RETURN for yes, 0 for no)'))
%roundLength = roundIndices(:,2) - roundIndices(:,1);  %Finds median round length and deletes outliers
%medianRoundLength = median(roundLength);
%iqrRoundLength = iqr(roundLength);
%numRemoved = length(roundIndices) - sum(roundLength < (medianRoundLength + 1.5 * iqrRoundLength) ...
%    & roundLength > (medianRoundLength - 1.5 * iqrRoundLength));
%disp ( [ num2str(numRemoved) ' outlier rounds removed' ] );
%roundIndices = roundIndices(roundLength < (medianRoundLength + 1.5 * iqrRoundLength) ...
%    & roundLength > (medianRoundLength - 1.5 * iqrRoundLength),:);

%clear meanRoundLength stdRoundLength numRemoved roundLength movSum

end

        
        




