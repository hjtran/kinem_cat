function [bins, badBins] = BinFilter(bins,binSize)

medianBins = median(bins(:,2:end));
if mean(medianBins,2) < 0
    sign = -1;
elseif mean(medianBins,2) >= 0
    sign = 1;
end
spike = zeros(size(bins));
spike(:,1) = bins(:,1);
if sign == -1
    for i=1:size(bins,1);
        spike(i,2:end) = medianBins*1.45 < bins(i,2:end) & medianBins*0.55 > bins(i,2:end);
    end
    lowvalueBins = find(medianBins > -10 & medianBins < 10);
    for i=1:size(bins,1)
        spike(i,lowvalueBins+1) = -50 < bins(i,lowvalueBins+1) & 50 > bins(i,lowvalueBins+1);
    end
end
if sign == 1
    for i=1:size(bins,1);
        spike(i,2:end) = medianBins*1.45 > bins(i,2:end) & medianBins*0.55 < bins(i,2:end);
    end
    lowvalueBins = find(medianBins > -10 & medianBins < 10);
    for i=1:size(bins,1)
        spike(i,lowvalueBins+1) = -50 < bins(i,lowvalueBins+1) & 50 > bins(i,lowvalueBins+1);
    end
end
sumSpike = [bins(:,1) sum(spike(:,2:end),2)];
badRounds = sumSpike(sumSpike(:,2) < (round(binSize*0.85)),1);
badBins = bins(badRounds,:);
bins(badRounds,:) = [];
spike(badRounds,:) = [];
clear badRounds

sumSpike = [bins(:,1) sum(spike(:,2:end),2)];
interpRounds = sumSpike(:,2) < binSize;
interpBins = bins(interpRounds,:);
interpBins(interpBins(:,2) < 0.0001 & interpBins(:,2) > -0.0001,2) = medianBins(1);
interpBins(interpBins(:,end) < 0.0001 & interpBins(:,end) > -0.0001, end) = medianBins(end);
for i=1:size(interpBins,1)
    
    if sign == 1
        interpBins(medianBins(1)*1.45 < interpBins(:,2) | medianBins(1)*0.55 > interpBins(:,2),2) = medianBins(1);
        interpBins(medianBins(end)*1.45 < interpBins(:,end) | medianBins(end)*0.55 > interpBins(:,end), end) = medianBins(end);
        iBin = interpBins(i,2:end);
        ng = find(medianBins*1.45 > iBin & medianBins*0.55 < iBin);
    end
    if sign == -1
        interpBins(medianBins(1)*1.45 > interpBins(:,2) | medianBins(1)*0.55 < interpBins(:,2),2) = medianBins(1);
        interpBins(medianBins(end)*1.45 > interpBins(:,end) | medianBins(end)*0.55 > interpBins(:,end), end) = medianBins(end);
        iBin = interpBins(i,2:end);
        ng = find(medianBins*1.45 < iBin & medianBins*0.55 > iBin);
    end

    
    for j = 1:length(ng)-1
        w = ng(j+1)-ng(j);
        if w ~= 1
            iBin(ng(j):ng(j+1)) = spline([ng(j) ng(j+1)], [iBin(ng(j)) iBin(ng(j+1))], ng(j):ng(j+1));
        end
    end
    interpBins(i,2:end) = iBin';
end
bins(interpRounds,:) = interpBins;

        