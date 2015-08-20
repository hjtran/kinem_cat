function [cl_1, cl_2] = RoundClusterer(unclustered, data)
% Clusters each round based on placement of first step.

matUnclustered = cell2mat(unclustered);
stIndices = zeros(1,length(matUnclustered));
for i=1:length(matUnclustered)
    stIndices(i) = matUnclustered(i).StanceIndices(1,2);
end

roIndices = zeros(1,length(matUnclustered));
for i=1:length(matUnclustered)
    roIndices(i) = matUnclustered(i).RoundIndices(1,1);
end


% column 4 - 6 are x,y,z , column 10 - 12 are vx,vy,vz

YZPoints = zeros(length(matUnclustered),2);
for i = 1:length(matUnclustered)
    YZPoints(i,:) = data(roIndices(i)+stIndices(i)-1,[4 5]);
end

clustResult = kmeans(YZPoints,2);


cl_1 = unclustered(clustResult == 1);
cl_2 = unclustered(clustResult == 2);
