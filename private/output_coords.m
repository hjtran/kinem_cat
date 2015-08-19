function output_coords(coords,clustNum,fileName,recNum,task,roundDurationStats)
% Outputs coordinate data into kinemresults file

fileres = 'kinemresults_coords.txt';
[fid2,mes] = fopen(fileres,'at'); % Opens existing text file, or creates a new file
[mes1,numerror]=ferror(fid2); % If file doesn't exist, an error message will be shown
if numerror==-1
    disp( sprintf('Could not open new file <<%s>> \n',fileres ));  
    disp(mes1);
else 
    disp( sprintf('File <<%s>> was opened \n',fileres));
end
            % Check for existence of existing file
fseek(fid2,0,'eof'); % New coordinate data will be saved at the end of the existing file
                        % otherwise the beginning of the new file
pos2=ftell(fid2);
if pos2 ~= 0
    titlefid2=0;
else   
    titlefid2=1; % Data written at the beginning of the file will indicate the creation of a new file
    disp( sprintf('New file <<%s>> has been created \n',fileres));
end            
if titlefid2==1 % If the file is new, the first line will include headings
                % and the numbers corresponding to each bin
    fprintf(fid2,'File Name,Task,Recording Number,Cluster Number,Round Number,'); 
    for i=1:6, fprintf(fid2,'St%dy,St%dz,',i,i); end
    for i=1:5, fprintf(fid2,'StrideY %d,StrideX %d,',i,i); end
    fprintf(fid2,['Mean Stance t, Std Stance t, Mean Swing t, Std Stance t,'  ...
        'Mean Step t, Std Step t, Duty Factor']);
    fprintf(fid2,'\n\n');
end

fprintf(fid2,fileName); % This line will describe the data
fprintf(fid2,',%s,%s,%d,\n',task,recNum,clustNum);

for i=1:size(coords,1)-2 
    fprintf(fid2,',,,,');
      for j=1:size(coords,2);
         fprintf(fid2, '%.4f,',coords(i,j)); 
      end
      for j=1:size(roundDurationStats,2)
          fprintf(fid2, '%.4f,',roundDurationStats(i,j));
      end
      
    fprintf(fid2,'\n');
end

fprintf(fid2,',,,,AVG,'); % This lines gives the average of each step bin
for j=2:size(coords,2);
    fprintf(fid2, '%.4f,',coords(size(coords,1)-1,j));
end
for j=1:size(roundDurationStats,2)
      fprintf(fid2, '%.4f,',roundDurationStats(size(roundDurationStats,1)-1,j));
end
fprintf(fid2,'\n'); 
fprintf(fid2,',,,,STD,'); % This lines gives the stan. dev. of each step bin
for j=2:size(coords,2)
    fprintf(fid2, '%.4f,',coords(size(coords,1),j));
end
for j=1:size(roundDurationStats,2)
      fprintf(fid2, '%.4f,',roundDurationStats(size(roundDurationStats,1),j));
end
fprintf(fid2,'\n\n\n');

      