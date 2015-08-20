%Compares two stick figure step cycles side by side
Name = 'forward walking 4 lim_'; %'push loc hind limbs only_' %Beginning name of output .txt file EX: Forward_Channel103 do not have to put Channel103 in Name
Start = 8856; %4320 %Start of Cycle
Stop = 9087; %4700 %End of Cycle
Push = 8900; %4428
Arrow= 'Y'; %Yes if you want arrow to show 'N' if you do not
C = 1;  %%If Standing enter C = 0 If Stepping enter C = 1 
Direction = 'R'; %%Direction of Push 'R' or 'L' : case sensitive
Angles = 'N'; %If you have angle files enter 'Y' if not then enter 'N'
Animation = 'Y'; %If Animation = 'Y' then it will plot a animated figure from start to stop

%%%%%% Uncomment for input Dialog box; comment next 8 lines to bypass
% % imp = {'File Name up Channel#', 'Start Frame', 'Stop Frame', 'Frame of Push', 'Arrow [Y/N]', 'Standing or Stepping [0/1]', 'Direction of Push [L/R]', 'Angles [Y/N]'};
% % vars = inputdlg(imp, 'Stick Figure Input Dialog', 1, {Name, '', '', '', 'Y', '1', 'R', 'N'});
% % Name = char(vars(1));
% % Start = str2double(vars(2));
% % Stop = str2double(vars(3));
% % Push = str2double(vars(4));
% % Arrow = char(vars(5));
% % C = str2double(vars(6));
% % Direction - char(vars(7));
% % Angles = char(vars(8);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Opens Normal Stick Figure; If you changed name you must change name of file here
if C
    load('forward walking 4 lim_.mat') %load forward walking 4 lim_.mat %load Normal_Stepping_Stick.mat %file for Push loc Hind Limbs only
    ds = 6;
else
    load Normal_Standing_Stick.mat
    ds = 2;
end

%Loads Data and Fills Gaps up to 15 Frames Long
xyz = [];
for n = [8 7 6 5 4] %Channel Numbers %Switch MTP and TOE are 4 & 5
    g = [Name 'Channel10' num2str(n) '.txt'];
    z = dlmread(g, '', 31,0);
    data = z(:,4:6);
    miss = find(data == 0);
    if isempty(miss)
    else
        data = fillgaps(data);
    end    
    xyz = [xyz data];
    clear data miss g 
end

%Ensures that Start and Stop are created uses whole Trial if start and stop not entered
if Start ~= 0 && Stop ~= 0
else
    Start = 1;
    Stop = size(z,1);
end

%Low Pass Filters Data at 5 HZ with 1/2 Sampling rate = 45HZ: Change if need to be higher or lower
[B,A] = butter(4, 3/45,'low');
xyz = filtfilt(B,A,xyz);


%%Splits Data into respective coordinate Frames
xdata = xyz(Start:Stop,1:3:end); %Vertical
ydata = xyz(Start:Stop,2:3:end); %Horizontal
zdata = xyz(Start:Stop,3:3:end); %ML

%Plots toe trajectory and stick figure cartoon
figure(1)
plot3(ydata(:,end), zdata(:,end), xdata(:,end));
hold on
if strcmp(Arrow, 'Y')
    plot3(ydata(Push-Start+1,end), zdata(Push-Start+1,end), xdata(Push-Start+1,end), 'marker', 'd', 'markeredgecolor', 'r', 'markerfacecolor', 'r')
end
plot3(ydata(1,end), zdata(1,end), xdata(1,end), 'marker', 'x', 'markeredgecolor', 'r', 'markersize', 10)
if strcmp(Animation, 'Y')
plot_Locomotion(ydata, zdata, xdata, 1); %Last number represents number of repeats
end
%Plots Stick Figures
%Plots Normal Data
figure(2);
for j = 1:ds:size(Nxdata, 1)
    plot3(Nydata(j,:), Nzdata(j,:), Nxdata(j,:), 'color', 'b', 'marker', 'o', 'markeredgecolor', 'r')
    hold on
end

if strcmp(Direction, 'L')
    % Plots Pushed Data if L push
    for n = 1:ds:size(xdata,1)
        if n > Push-Start-ds/2-1 && n < Push-Start+ds/2 && strcmp(Arrow, 'Y')
            plot3(ydata(n,1:end), zdata(n,1:end)+150, xdata(n,1:end), 'color', 'k', 'marker', 'o', 'markeredgecolor', 'r')
            hold on
            %Arrow
            line([ydata(n,1), ydata(n,1)], [zdata(n,1)+149, zdata(n,1)+126], [xdata(n,1)+1, xdata(n,1)+1], 'color', 'k')
            plot3(ydata(n,1), zdata(n,1)+149, xdata(n,1)+1, 'marker', 'd', 'markeredgecolor', 'k', 'markerfacecolor', 'k', 'markersize', 6)
        elseif n < Push - Start -ds/2 -1
            plot3(ydata(n,1:end), zdata(n,1:end)+150, xdata(n,1:end), 'color', 'k', 'marker', 'o', 'markeredgecolor', 'm')
            hold on
        else
            plot3(ydata(n,1:end), zdata(n,1:end)+150 , xdata(n,1:end), 'color', 'k', 'marker', 'o', 'markeredgecolor', 'm')
            hold on
        end
    end
else
    % Plots Pushed Data if R push
    for n = 1:ds:size(xdata,1)
        if n > Push-Start-ds/2-1 && n < Push-Start+ds/2 && strcmp(Arrow, 'Y')
            plot3(ydata(n,1:end), zdata(n,1:end)+150, xdata(n,1:end), 'color', 'k', 'marker', 'o', 'markeredgecolor', 'r')
            hold on
            %Arrow
            line([ydata(n,1), ydata(n,1)], [zdata(n,1)+151, zdata(n,1)+175], [xdata(n,1)+1, xdata(n,1)+1], 'color', 'k')
            plot3(ydata(n,1), zdata(n,1)+151, xdata(n,1)+1, 'marker', 'd', 'markeredgecolor', 'k', 'markerfacecolor', 'k', 'markersize', 6)
        else
            plot3(ydata(n,1:end), zdata(n,1:end)+150 , xdata(n,1:end), 'color', 'k', 'marker', 'o', 'markeredgecolor', 'm')
            hold on
        end
    end
end

% xmin = min(min(ydata))*0.9;
% xmax = max(max(ydata))*1.1;
% ymin = min(min(zdata))*0.9;
% ymax = max(max(zdata))*1.1;
% zmin = min(min(xdata))*0.8;
% zmax = max(max(xdata))*1.1;
% axis([xmin, xmax, ymin, ymax, zmin, zmax]);
axis equal
view([95,25])
box on

clear xyz z 

%%%%%ANGLES%%%%%
if strcmp(Angles, 'Y')
    H = dlmread([Name 'Hip.txt'], '', 29,2);
    H = 180-H(:,1);
    K = dlmread([Name 'Knee.txt'], '', 29,2);
    K = 180-K(:,1);
    An = dlmread([Name 'Ankle.txt'], '', 29, 2);
    An = 180-An(:,1);
    M = dlmread([Name 'MTP.txt'], '', 29,2);
    M = 180+M(:,1);
    Ang = [H,K,An,M];
    Ang = filtfilt(B,A,Ang);


    figure(5)
    subplot(4,1,1)
    plot(Ang(Start:Stop,1));
    title('Hip Ang')
    hold on
    if strcmp(Arrow, 'Y')
    line([Push-Start+1 Push-Start+1], [Ang(Push,1)+1 Ang(Push,1)+11])
    plot(Push-Start+1, Ang(Push,1)+1, 'marker', 'v', 'markerfacecolor', 'b')
    end
    
    subplot(4,1,2)
    plot(Ang(Start:Stop,2));
    title('Knee Ang')
    hold on

    subplot(4,1,3)
    plot(Ang(Start:Stop,3));
    title('Ankle Ang')
    hold on

    subplot(4,1,4)
    plot(Ang(Start:Stop,4));
    title('MTP Ang')
    hold on
end

%%% Plots surface and mesh plots-> the Artsy ones
% figure(3)
% mesh(Nydata(1:ds:end,:), Nzdata(1:ds:end,:), Nxdata(1:ds:end,:))
% hold on
% mesh(ydata(1:ds:end,:), zdata(1:ds:end,:)+150, xdata(1:ds:end,:))
% qq = Push-Start+1;
% line([ydata(qq,1), ydata(qq,1)], [zdata(qq,1)+151, zdata(qq,1)+175], [xdata(qq,1)+1, xdata(qq,1)+1], 'color', 'k')
% axis equal
% 
% 
% 
% figure(4)
% surf(Nydata(1:ds:end,:), Nzdata(1:ds:end,:), Nxdata(1:ds:end,:))
% hold on
% surf(ydata(1:ds:end,:), zdata(1:ds:end,:)+150, xdata(1:ds:end,:))
% qq = Push-Start+1;
% line([ydata(qq,1), ydata(qq,1)], [zdata(qq,1)+151, zdata(qq,1)+175], [xdata(qq,1)+1, xdata(qq,1)+1], 'color', 'k')
% axis equal

[LegL LegL2] = leg_calc(ydata, zdata, xdata); %Horizontal, ML, Vertical
figure(3);
plot(LegL);
hold on

