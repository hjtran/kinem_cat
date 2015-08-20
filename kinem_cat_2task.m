function kinem_cat_2task(stepNum,task1,task2,varargin)
p = path;
p1 = userpath;
p1(end) = [];
task1 = [upper(task1(1)) lower(task1(2:end))];
task2 = [upper(task2(1)) lower(task2(2:end))];
if nargin == 4
    params = varargin{1};
end


%    listFol = dir([p1 fileNames{i}]);  % Capitalize first letter of task folders
%    listFol(1:2) = [];
%    for j=1:length(listFol)
%        transname = [p1 fileNames{i} '\' listFol(j).name 't'];
%        movefile([p1 fileNames{i} '\' listFol(j).name],transname);
%        movefile(transname,[p1 fileNames{i} '\' upper(listFol(j).name(1)) lower(listFol(j).name(2:end))]);
%    end
userpath([p1 '\' task1]);
if nargin == 3
    [flatBins, badFlatBins, flatBinsStats,~,~,~,params2] = kinem_cat_1task(fileName, task1, stepNum);
elseif nargin == 4
    [flatBins, badFlatBins, flatBinsStats,~,~,~,params2] = kinem_cat_1task('False',params);
end
path(p);
userpath([p1 '\' task2]);
if nargin == 3
    [rockBins badRockBins rockBinsStats] = kinem_cat_1task(fileName, task2, stepNum);
elseif nargin == 4
    [rockBins badRockBins rockBinsStats] = kinem_cat_1task('False',params);
end
[~, pv] = ttest2(flatBins, rockBins);
pv(:,1) = [];
flatBinsStats(end+1,:) = pv; 
output_2task(flatBins,badFlatBins,flatBinsStats,rockBins,badRockBins,rockBinsStats,params2,task1,task2);
path(p);

