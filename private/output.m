function output(stepBins,stepBinsStats,clustNum,fileName,recNum,stepNum,task,prop,binSize)
% Outputs data into kinemresults file

fileres = 'kinemresults.txt';
[fid2,mes] = fopen(fileres,'at'); % Opens kinemresults.txt file
                                    % If the file doesn't exist, a new file
                                    % will created
[mes1,numerror]=ferror(fid2); 
if numerror==-1 % If the file does not exist, error message will appear
    disp( sprintf('Could not open new file <<%s>> \n',fileres ));  
    disp(mes1);
else
    disp( sprintf('File <<%s>> was opened \n',fileres));
end
            % Check for existence of the file
fseek(fid2,0,'eof'); % Round data will be saved at the end of the existing file 
                        % otherwise at the beginning of the new file
pos2=ftell(fid2);  
if pos2 ~= 0
    titlefid2=0;
else   
    titlefid2=1; % Data written at the beginning of the file will indicate the creation of a new file
    disp( sprintf('New file <<%s>> has been created \n',fileres));
end            
if titlefid2==1 % If the file is new, the first line will include headings
                % and the numbers corresponding to each bin
    fprintf(fid2,'File Name,Task,Recording Number,Cluster Number,Step Number,Property,Round Number,'); 
    for i=1:binSize, fprintf(fid2,'%d,',i); end
    fprintf(fid2,'\n\n');
end

fprintf(fid2,fileName); % This line will describe the data
fprintf(fid2,',%s,%s,%d,%d,%s\n',task,recNum,clustNum,stepNum,prop);

for i=1:size(stepBins,1) % The next lines list the round number and
                        % corresponding step bins
    fprintf(fid2,',,,,,,');
      for j=1:binSize+1
         fprintf(fid2, '%.2f,',stepBins(i,j));
      end
    fprintf(fid2,'\n\n');
end

fprintf(fid2,',,,,,,AVG,'); % This line gives the average of each step bin
for j=1:binSize
    fprintf(fid2, '%.2f,',stepBinsStats(1,j)); 
end
fprintf(fid2,'\n');
fprintf(fid2,',,,,,,STD,'); % This line gives the stan. dev. of each step bin
for j=1:binSize
    fprintf(fid2, '%.2f,',stepBinsStats(2,j));
end
fprintf(fid2,'\n');
fprintf(fid2,',,,,,,SEM,'); % This line gives the standard error of mean of each step bin
for j=1:binSize
    fprintf(fid2, '%.2f,',stepBinsStats(3,j));
end
fprintf(fid2,'\n');
fprintf(fid2,',,,,,,2xSEM,'); % This line gives the twice the standard error of mean of each step bin
for j=1:binSize
    fprintf(fid2, '%.2f,',stepBinsStats(4,j));
end
fprintf(fid2,'\n\n');

      