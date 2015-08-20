function out = fillgaps_alldata(data)
% Fill gaps for P, V, A, for vz glitches (flickers, etc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
specificRangeFilter = 1;
lwrLim = -700;
uprLim = -489;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ng = find(data(:,3)); % Finds all of the indexes that are nonzero of the data
for n = 2:length(ng)-2 % Starts a for loop going through all of the indexes
    w = ng(n+1) - ng(n); % If consecutive elements have a difference of one, no flicker
    if w == 1
    elseif w < 37   %16 % Else, there is a flicker, if flicker is less than 37, interpolates
        t = [ng(n) ng(n+1)]; % and replaces the flickers
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

if specificRangeFilter % Uses same process as above, but searches for values outside
                       % of range and interpolates for those if less than
                       % 60 in length.
    ng = find((data(:,3) > lwrLim & data(:,3) < uprLim) | data(:,3) == 0);
    for n = 2:length(ng)-2
        w = ng(n+1) - ng(n);
        if w == 1
        elseif w < 60   %16
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
end

% Same as above, but searches for spikes by searching for differences from
% a moving median that are larger than 1%.
xdata = data(:,3);
medData = medfilt1(xdata,51); % Add argument to limit blocksize and conserve memory, will take longer % 37
ng = find((xdata) > (1.01*medData) & (xdata) < (0.99*medData));
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


