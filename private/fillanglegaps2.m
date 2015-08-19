function out = fillanglegaps2(data)

xdata = data(:,3);
medData = medfilt1(xdata,37);
ng = find(xdata < 1.2*medData & xdata > 0.8*medData);
for n = 2:length(ng)-2
    w = ng(n+1) - ng(n);
    if w == 1
    elseif w < 37   %16
        t = [ng(n) ng(n+1)];
        x = data(t,3);
        tt = ng(n):ng(n+1);
        data(ng(n):ng(n+1),3) = spline(t, x, tt);
        for i = ng(n)-1:ng(n+1)
            data(i+1,6) = ((data(i+1,3)-data(i,3))/(data(i+1,2)-data(i,2)))*100;
        end
    end
end
out = data;


