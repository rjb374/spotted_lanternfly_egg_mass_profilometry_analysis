function [flagTable, flagArray] = flag_summary_stats(summaryStats, collectiveData)
% FLAG_SUMMARY_STATS Test sample metrics against population mean +/- 1 SD.
%
% A value of 1 indicates that the sample statistic lies within one standard
% deviation of the pooled treatment mean; 0 indicates that it lies outside.

    heightMean = mean(collectiveData.allPeakHeights);
    heightStd = std(collectiveData.allPeakHeights);
    angleMean = mean(collectiveData.allAngles);
    angleStd = std(collectiveData.allAngles);
    areaMean = mean(collectiveData.allAreas);
    areaStd = std(collectiveData.allAreas);
    volumeMean = mean(collectiveData.allVolumes);
    volumeStd = std(collectiveData.allVolumes);

    numDatasets = length(summaryStats);
    flagArray = zeros(numDatasets, 4); % Columns: Height, Angle, Area, Volume

    for i = 1:numDatasets
        stats = summaryStats(i);
        flagArray(i, 1) = stats.MeanHeight >= (heightMean - heightStd) && stats.MeanHeight <= (heightMean + heightStd);
        flagArray(i, 2) = stats.MeanAngle >= (angleMean - angleStd) && stats.MeanAngle <= (angleMean + angleStd);
        flagArray(i, 3) = stats.MassArea >= (areaMean - areaStd) && stats.MassArea <= (areaMean + areaStd);
        flagArray(i, 4) = stats.MassVolume >= (volumeMean - volumeStd) && stats.MassVolume <= (volumeMean + volumeStd);
    end

    flagArray = int8(flagArray);
    filenames = {summaryStats.Filename}';
    flagTable = table(filenames, flagArray(:,1), flagArray(:,2), flagArray(:,3), flagArray(:,4), ...
        'VariableNames', {'Filename', 'Flag_MeanHeight', 'Flag_Angle', 'Flag_MassArea', 'Flag_MassVolume'});
end
