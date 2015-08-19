function out = fillgaps(data)
% Fill gaps for P, V, A, for vz glitches (flickers, etc)
ng = find(data(:,3));
for n = 2:length(ng)-2
    w = ng(n+1) - ng(n);
    if w == 1
    elseif w < 37   % 16
        t = [ng(n) ng(n+1)];
        x = data(t,3);
        y = data(t,4);
        z = data(t,5);
        tt = ng(n):ng(n+1);
        data(ng(n):ng(n+1),3) = spline(t, x, tt);
        data(ng(n):ng(n+1),4) = spline(t, y, tt);
        data(ng(n):ng(n+1),5) = spline(t, z, tt);
        for i = ng(n)-1:ng(n+1)
            data(i+1,6) = ((data(i+1,3)-data(i,3))/(data(i+1,2)-data(i,2)))*100;
            data(i+1,7) = ((data(i+1,4)-data(i,4))/(data(i+1,2)-data(i,2)))*100;
            data(i+1,8) = ((data(i+1,5)-data(i,5))/(data(i+1,2)-data(i,2)))*100;
        end
        for i = ng(n)-1:ng(n+1)
            data(i+1,9) = ((data(i+1,6)-data(i,6))/(data(i+1,2)-data(i,2)))*100;
            data(i+1,10) = ((data(i+1,7)-data(i,7))/(data(i+1,2)-data(i,2)))*100;
            data(i+1,11) = ((data(i+1,8)-data(i,8))/(data(i+1,2)-data(i,2)))*100;            
        end
    end
end

xdata = data(:,3);
medData = medfilt1(xdata,37); % Add argument to limit blocksize and conserve memory, will take longer
ng = find((xdata) > (1.1*medData) & (xdata) < (0.9*medData));
%ng = find(data(:,3)>0);
for n = 2:length(ng)-2
    w = ng(n+1) - ng(n);
    if w == 1
    elseif w < 37   %16
        t = [ng(n) ng(n+1)];
        x = data(t,3);
        y = data(t,4);
        z = data(t,5);
        tt = ng(n):ng(n+1);
        data(ng(n):ng(n+1),3) = spline(t, x, tt);
        data(ng(n):ng(n+1),4) = spline(t, y, tt);
        data(ng(n):ng(n+1),5) = spline(t, z, tt);
        for i = ng(n)-1:ng(n+1)
            data(i+1,6) = ((data(i+1,3)-data(i,3))/(data(i+1,2)-data(i,2)))*100;
            data(i+1,7) = ((data(i+1,4)-data(i,4))/(data(i+1,2)-data(i,2)))*100;
            data(i+1,8) = ((data(i+1,5)-data(i,5))/(data(i+1,2)-data(i,2)))*100;
        end
        for i = ng(n)-1:ng(n+1)
            data(i+1,9) = ((data(i+1,6)-data(i,6))/(data(i+1,2)-data(i,2)))*100;
            data(i+1,10) = ((data(i+1,7)-data(i,7))/(data(i+1,2)-data(i,2)))*100;
            data(i+1,11) = ((data(i+1,8)-data(i,8))/(data(i+1,2)-data(i,2)))*100;            
        end
    end
end


out = data;


