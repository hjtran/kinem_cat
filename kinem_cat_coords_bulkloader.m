clear;
restoredefaultpath;
p = path;
basepath = 'C:\Users\Joey\Documents\Documents\Barrows Work\ALL TEXT FILES2\';
listOfFiles = { '10.04.13' ...
                '10.02.13' ...
                '9.30.13' ...
                '9.28.13' ...
                '7.28.13' ...
                '7.27.13' ...
                '7.25.13' ...
                '7.21.13' ...
                '7.19.13' ...
                '7.17.13' ...
                '7.16.13' ...
                }; 
task = 'Rocks';
for i = 1:length(listOfFiles)
    disp([listOfFiles{i} ' is being processed'])
    path([basepath listOfFiles{i} '\' task],p);
    kinem_cat_coord(listOfFiles{i},task);
    path(p)
end
%Unanalyzed Files: 6.25.13 7.23.13
 

