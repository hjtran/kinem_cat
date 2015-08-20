function output_coords(coords,clustNum,fileName,recNum,task,roundDurationStats)
% Outputs coordinate data into kinemresults file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stepLim = 6;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fileres = ['kinemresults_coord_' task '.txt'];
[fid2,mes] = fopen(fileres,'at');
[mes1,numerror]=ferror(fid2);
if numerror==-1
    disp( sprintf('Could not open new file <<%s>> \n',fileres ));  
    disp(mes1);
else 
    disp( sprintf('File <<%s>> was opened \n',fileres));
end
            % Check for existence
fseek(fid2,0,'eof');
pos2=ftell(fid2);
if pos2 ~= 0
    titlefid2=0;
else   
    titlefid2=1;
    disp( sprintf('New file <<%s>> has been created \n',fileres));
end            
if titlefid2==1 
    fprintf(fid2,'File Name,Task,Recording Number,Cluster Number,Round Number,'); 
    for i=1:stepLim, fprintf(fid2,'St%dy,St%dz,',i,i); end
    for i=1:stepLim-1, fprintf(fid2,'StrideY %d,StrideZ %d,',i,i); end
    for i=1:stepLim-1, fprintf(fid2,'Stride Length %d,',i); end
    fprintf(fid2,['Mean Stance time, Std Stance time, Mean Swing time, Std Stance time,'  ...
        'Mean Step t, Std Step t, Duty Factor']);
    fprintf(fid2,'\n\n');
end

fprintf(fid2,fileName);
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

fprintf(fid2,',,,,AVG,');
for j=2:size(coords,2);
    fprintf(fid2, '%.4f,',coords(size(coords,1)-1,j));
end
for j=1:size(roundDurationStats,2)
      fprintf(fid2, '%.4f,',roundDurationStats(size(roundDurationStats,1)-1,j));
end
fprintf(fid2,'\n');
fprintf(fid2,',,,,STD,');
for j=2:size(coords,2)
    fprintf(fid2, '%.4f,',coords(size(coords,1),j));
end
for j=1:size(roundDurationStats,2)
      fprintf(fid2, '%.4f,',roundDurationStats(size(roundDurationStats,1),j));
end
fprintf(fid2,'\n\n\n');

      