function output(stepBins,badBins,stepBinsStats,clustNum,fileName,recNum,stepNum,task,prop,binSize)
% Outputs data into kinemresults file

fileres = 'kinemresults.txt';
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
    fprintf(fid2,'File Name,Task,Recording Number,Cluster Number,Step Number,Property,Round Number,'); 
    for i=1:binSize, fprintf(fid2,'%d,',i); end
    fprintf(fid2,'\n\n');
end

fprintf(fid2,fileName);
fprintf(fid2,',%s,%s,%d,%d,%s\n',task,recNum,clustNum,stepNum,prop);

for i=1:size(stepBins,1)
    fprintf(fid2,',,,,,,');
      for j=1:binSize+1
         fprintf(fid2, '%.2f,',stepBins(i,j));
      end
    fprintf(fid2,'\n');
end

fprintf(fid2,'Bad Rounds');
for i=1:size(badBins,1)
    fprintf(fid2,',,,,,,');
      for j=1:binSize+1
         fprintf(fid2, '%.2f,',badBins(i,j));
      end
    fprintf(fid2,'\n');
end


fprintf(fid2,'\n');
fprintf(fid2,',,,,,,AVG,');
for j=1:binSize
    fprintf(fid2, '%.2f,',stepBinsStats(1,j));
end
fprintf(fid2,'\n');
fprintf(fid2,',,,,,,STD,');
for j=1:binSize
    fprintf(fid2, '%.2f,',stepBinsStats(2,j));
end
fprintf(fid2,'\n');
fprintf(fid2,',,,,,,SEM,');
for j=1:binSize
    fprintf(fid2, '%.2f,',stepBinsStats(3,j));
end
fprintf(fid2,'\n');
fprintf(fid2,',,,,,,2xSEM,');
for j=1:binSize
    fprintf(fid2, '%.2f,',stepBinsStats(4,j));
end
fprintf(fid2,'\n\n');

      