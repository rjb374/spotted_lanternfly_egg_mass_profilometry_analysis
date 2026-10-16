function [collectiveData, individualData, summaryStats] = Output_data(folder)
% OUTPUT_DATA Process all KEYENCE CSV height maps in a treatment folder.
%
% INPUT
%   folder - Folder containing source CSV files.
%
% OUTPUTS
%   collectiveData - Structure containing pooled measurements across samples.
%   individualData - Table containing per-sample measurements.
%   summaryStats   - Structure array containing per-sample summary statistics.
%
% The function applies the complete per-sample workflow: load, normalize,
% detect eggs, calculate spacing/orientation, calculate area/volume, and
% aggregate the results used by Full_analysis.m.

    files = dir(fullfile(folder, '*.csv'));
    if isempty(files)
        error('Output_data:NoCSVFiles', 'No CSV files were found in folder: %s', folder);
    end

    % Sort by filename so processing order is deterministic.
    [~, order] = sort({files.name});
    files = files(order);

    % Storage for pooled population-level measurements.
    allPeakHeights = []; allXSpacings = []; allYSpacings = []; allXPeaks = []; allYPeaks = [];
    allEggCounts = []; xLengths_proj_pop = []; yLengths_proj_pop = []; allAngles = [];
    allVolumes = []; allAreas = []; individualData = table(); summaryStats = [];

    for k = 1:length(files)
        filePath = fullfile(folder, files(k).name);

        [metadata, heightData] = load_egg_csv(filePath);
        [X, Y, normHeightData, xyCalibration] = normalize_height(heightData, metadata);
        [eggCoords, peakHeights, numEggs] = detect_eggs(X, Y, normHeightData, xyCalibration);
        [xProj, yProj, normAngles, xPeak, yPeak] = analyze_spacing(eggCoords);
        [massArea, massVolume] = calculateAreaVolume(normHeightData, xyCalibration);

        summaryStats = [summaryStats; collect_stats(files(k).name, ... %#ok<AGROW>
            numEggs, peakHeights, xProj, xPeak, yProj, yPeak, normAngles, massArea, massVolume)];

        individualData.filename{k,1} = files(k).name;
        individualData.numEggs{k,1} = numEggs;
        individualData.peakHeights{k,1} = peakHeights';
        individualData.xProj{k,1} = xProj;
        individualData.xPeak{k,1} = xPeak;
        individualData.yProj{k,1} = yProj;
        individualData.yPeak{k,1} = yPeak;
        individualData.normAngles{k,1} = normAngles;
        individualData.massArea{k,1} = massArea;
        individualData.massVolume{k,1} = massVolume;

        % Aggregate measurements for treatment-level plots/statistics.
        allPeakHeights = [allPeakHeights; peakHeights(:)]; %#ok<AGROW>
        allXSpacings = [allXSpacings; xProj(:)]; %#ok<AGROW>
        allYSpacings = [allYSpacings; yProj(:)]; %#ok<AGROW>
        allXPeaks = [allXPeaks; xPeak]; %#ok<AGROW>
        allYPeaks = [allYPeaks; yPeak]; %#ok<AGROW>
        allAngles = [allAngles, normAngles]; %#ok<AGROW>
        allEggCounts = [allEggCounts; numEggs]; %#ok<AGROW>
        xLengths_proj_pop = [xLengths_proj_pop; xProj(:)]; %#ok<AGROW>
        yLengths_proj_pop = [yLengths_proj_pop; yProj(:)]; %#ok<AGROW>
        allVolumes = [allVolumes; massVolume]; %#ok<AGROW>
        allAreas = [allAreas; massArea]; %#ok<AGROW>
    end

    collectiveData = struct( ...
        'allPeakHeights', allPeakHeights, ...
        'allXSpacings', allXSpacings, ...
        'allYSpacings', allYSpacings, ...
        'allXPeaks', allXPeaks, ...
        'allYPeaks', allYPeaks, ...
        'allAngles', allAngles, ...
        'allEggCounts', allEggCounts, ...
        'xLengths_proj_pop', xLengths_proj_pop, ...
        'yLengths_proj_pop', yLengths_proj_pop, ...
        'allVolumes', allVolumes, ...
        'allAreas', allAreas);
end
