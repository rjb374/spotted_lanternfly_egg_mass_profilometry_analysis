%% Egg mass surface analysis
% Main analysis script for covered and uncovered egg-mass height maps.
% Set rebuildFromCSV = true to regenerate processed data from the source CSV
% files. Set it to false to use the cached MAT files when they are available.

clearvars
close all; clc

rebuildFromCSV = true; % Recommended for reproducible analysis from source data.

% =========================== Data ===================================
% Define filenames for cached processed data.
uncMatFile = 'Egg_uncovered_data.mat';
covMatFile = 'Egg_covered_data.mat';

% === Uncovered ===
if ~rebuildFromCSV && exist(uncMatFile, 'file')
    load(uncMatFile, 'collectiveData_unc', 'individualData_unc', 'summaryStats_unc');
    disp('Loaded uncovered data from cached MAT file.');
else
    [collectiveData_unc, individualData_unc, summaryStats_unc] = Output_data('Egg uncovered');
    save(uncMatFile, 'collectiveData_unc', 'individualData_unc', 'summaryStats_unc');
    disp('Uncovered CSV data processed and cache saved.');
end

% === Covered ===
if ~rebuildFromCSV && exist(covMatFile, 'file')
    load(covMatFile, 'collectiveData_cov', 'individualData_cov', 'summaryStats_cov');
    disp('Loaded covered data from cached MAT file.');
else
    [collectiveData_cov, individualData_cov, summaryStats_cov] = Output_data('Egg covered');
    save(covMatFile, 'collectiveData_cov', 'individualData_cov', 'summaryStats_cov');
    disp('Covered CSV data processed and cache saved.');
end

%% =========================== Data visualisation ========================

fig = figure('Units','normalized','OuterPosition',[0 0 1 1]);
histogram(collectiveData_unc.allPeakHeights, 'BinWidth', 0.1, 'FaceColor', 'b', 'FaceAlpha', 0.5); hold on;
histogram(collectiveData_cov.allPeakHeights, 'BinWidth', 0.1, 'FaceColor', 'r', 'FaceAlpha', 0.5);
xlabel('Peak Height (mm)', 'FontSize', 50);
ylab = ylabel('Frequency', 'FontSize', 50);
yticks(0:100:300);
xlim([0 5]);
ylim([0 350]);
pbaspect([1.5 1 1])
ylab.Position(1) = ylab.Position(1) - 0.4;
ax=gca;
ax.FontSize = 36;
ax.LineWidth = 2;
lx = legend('Uncovered', 'Covered', 'FontSize', 50);
set(lx, 'Box', 'off');
grid off;
exportgraphics(fig, 'histogram_egg_peak_heights.png', 'Resolution', 300);

fig = figure('Units','normalized','OuterPosition',[0 0 1 1]);
histogram(collectiveData_unc.allYSpacings, 'BinWidth', 0.1, 'FaceColor', 'b', 'FaceAlpha', 0.5); hold on;
histogram(collectiveData_cov.allYSpacings, 'BinWidth', 0.1, 'FaceColor', 'r', 'FaceAlpha', 0.5);
xlabel('Y-direction Distance (mm)', 'FontSize', 50);
ylab = ylabel('Frequency', 'FontSize', 50);
yticks(0:500:1500);
xlim([0 20]);
ylim([0 1600]);
pbaspect([1.5 1 1])
ylab.Position(1) = ylab.Position(1) - 2;
ax=gca;
ax.FontSize = 36;
ax.LineWidth = 2;
lx = legend('Uncovered', 'Covered', 'FontSize', 50);
set(lx, 'Box', 'off');
grid off;
exportgraphics(fig, 'histogram_allYSpacings.png', 'Resolution', 300);

fig = figure('Units','normalized','OuterPosition',[0 0 1 1]);
histogram(collectiveData_unc.allXSpacings, 'BinWidth', 0.1, 'FaceColor', 'b', 'FaceAlpha', 0.5); hold on;
histogram(collectiveData_cov.allXSpacings, 'BinWidth', 0.1, 'FaceColor', 'r', 'FaceAlpha', 0.5);
xlabel('X-direction Distance (mm)', 'FontSize', 50);
ylab = ylabel('Frequency', 'FontSize', 50);
yticks(0:1000:5000);
xlim([0 8]);
ylim([0 5000]);
pbaspect([1.5 1 1])
ylab.Position(1) = ylab.Position(1) - 0.8;
ax=gca;
ax.FontSize = 36;
ax.LineWidth = 2;
lx = legend('Uncovered', 'Covered', 'FontSize', 50);
set(lx, 'Box', 'off');
grid off;
exportgraphics(fig, 'histogram_allXSpacings.png', 'Resolution', 300);

fig = figure('Units','normalized','OuterPosition',[0 0 1 1]);
histogram(collectiveData_unc.allXPeaks, 'BinWidth', 0.1, 'FaceColor', 'b', 'FaceAlpha', 0.5); hold on;
histogram(collectiveData_cov.allXPeaks, 'BinWidth', 0.1, 'FaceColor', 'r', 'FaceAlpha', 0.5);
xlabel('X-direction Distance (mm)', 'FontSize', 50);
ylab = ylabel('Frequency', 'FontSize', 50);
yticks(0:5:25);
xlim([0 6]);
ylim([0 25]);
pbaspect([1.5 1 1])
ylab.Position(1) = ylab.Position(1) - 0.4;
ax=gca;
ax.FontSize = 36;
ax.LineWidth = 2;
lx = legend('Uncovered', 'Covered', 'FontSize', 50);
set(lx, 'Box', 'off');
grid off;
exportgraphics(fig, 'histogram_allXPeaks.png', 'Resolution', 300);

fig = figure('Units','normalized','OuterPosition',[0 0 1 1]);
histogram(collectiveData_unc.allYPeaks, 'BinWidth', 0.1, 'FaceColor', 'b', 'FaceAlpha', 0.5); hold on;
histogram(collectiveData_cov.allYPeaks, 'BinWidth', 0.1, 'FaceColor', 'r', 'FaceAlpha', 0.5);
xlabel('Y-direction Distance (mm)', 'FontSize', 50);
ylab = ylabel('Frequency', 'FontSize', 50);
yticks(0:5:30);
xlim([0 6]);
ylim([0 30]);
pbaspect([1.5 1 1])
ylab.Position(1) = ylab.Position(1) - 0.4;
ax=gca;
ax.FontSize = 36;
ax.LineWidth = 2;
lx = legend('Uncovered', 'Covered', 'FontSize', 50);
set(lx, 'Box', 'off');
grid off;
exportgraphics(fig, 'histogram_allYPeaks.png', 'Resolution', 300);

fig = figure('Units','normalized','OuterPosition',[0 0 1 1]);
histogram(collectiveData_unc.allAreas, 'BinWidth', 20, 'FaceColor', 'b', 'FaceAlpha', 0.5); hold on;
histogram(collectiveData_cov.allAreas, 'BinWidth', 20, 'FaceColor', 'r', 'FaceAlpha', 0.5);
xlabel('Area (mm^2)', 'FontSize', 50);
ylab = ylabel('Frequency', 'FontSize', 50);
yticks(0:6:18);
xlim([0 500]);
ylim([0 18]);
pbaspect([1.5 1 1])
ylab.Position(1) = ylab.Position(1) - 30;
ax=gca;
ax.FontSize = 36;
ax.LineWidth = 2;
lx = legend('Uncovered', 'Covered', 'FontSize', 50);
set(lx, 'Box', 'off');
grid off;
exportgraphics(fig, 'histogram_Area.png', 'Resolution', 300);

fig = figure('Units','normalized','OuterPosition',[0 0 1 1]);
histogram(collectiveData_unc.allVolumes, 'BinWidth', 50, 'FaceColor', 'b', 'FaceAlpha', 0.5); hold on;
histogram(collectiveData_cov.allVolumes, 'BinWidth', 50, 'FaceColor', 'r', 'FaceAlpha', 0.5);
xlabel('Volume (mm^3)', 'FontSize', 50);
ylab = ylabel('Frequency', 'FontSize', 50);
yticks(0:6:30);
xlim([0 1000]);
ylim([0 30]);
pbaspect([1.5 1 1])
ylab.Position(1) = ylab.Position(1) - 60;
ax=gca;
ax.FontSize = 36;
ax.LineWidth = 2;
lx = legend('Uncovered', 'Covered', 'FontSize', 50);
set(lx, 'Box', 'off');
grid off;
exportgraphics(fig, 'histogram_Volume.png', 'Resolution', 300);

fig = figure('Units','normalized','OuterPosition',[0 0 1 1]);
histogram(collectiveData_unc.allAngles, 'BinWidth', 3, 'FaceColor', 'b', 'FaceAlpha', 0.5); hold on;
histogram(collectiveData_cov.allAngles, 'BinWidth', 3, 'FaceColor', 'r', 'FaceAlpha', 0.5);
xlabel('Angle (degrees)', 'FontSize', 50);
ylab = ylabel('Frequency', 'FontSize', 50);
yticks(0:1000:6000);
xlim([0 180]);
ylim([0 6200]);
pbaspect([1.5 1 1])
ylab.Position(1) = ylab.Position(1) - 18;
ax=gca;
ax.FontSize = 36;
ax.LineWidth = 2;
lx = legend('Uncovered', 'Covered', 'FontSize', 50);
set(lx, 'Box', 'off');
grid off;
exportgraphics(fig, 'histogram_Angles.png', 'Resolution', 300);

fig = figure('Units','normalized','OuterPosition',[0 0 1 1]);
plot(collectiveData_unc.allEggCounts, 'DisplayName', 'Uncovered'); hold on;
plot(collectiveData_cov.allEggCounts, 'DisplayName', 'Covered');
xlabel('Sample', 'FontSize', 50);
ylab = ylabel('Detected egg count', 'FontSize', 50);
pbaspect([1.5 1 1])
ax=gca;
ax.FontSize = 36;
ax.LineWidth = 2;
lx = legend('FontSize', 50);
set(lx, 'Box', 'off');
grid off;
exportgraphics(fig, 'egg_counts_by_sample.png', 'Resolution', 300);

%% Summary Stats

% Uncovered
unc_heightMean = mean(collectiveData_unc.allPeakHeights);
unc_heightMedian = median(collectiveData_unc.allPeakHeights);
unc_heightStd = std(collectiveData_unc.allPeakHeights);
unc_spacingXMean = mean(collectiveData_unc.allXSpacings); 
unc_spacingXMedian = median(collectiveData_unc.allXSpacings); 
unc_spacingXStd = std(collectiveData_unc.allXSpacings);
unc_spacingYMean = mean(collectiveData_unc.allYSpacings); 
unc_spacingYMedian = median(collectiveData_unc.allYSpacings);
unc_spacingYStd = std(collectiveData_unc.allYSpacings);
unc_angleMean = mean(collectiveData_unc.allAngles);  
unc_angleMedian = median(collectiveData_unc.allAngles);  
unc_angleStd = std(collectiveData_unc.allAngles);
unc_areaMean = mean(collectiveData_unc.allAreas);    
unc_areaMedian = median(collectiveData_unc.allAreas);  
unc_areaStd = std(collectiveData_unc.allAreas);
unc_volumeMean = mean(collectiveData_unc.allVolumes);       
unc_volumeMedian = median(collectiveData_unc.allVolumes);     
unc_volumeStd = std(collectiveData_unc.allVolumes);

% Covered
cov_heightMean = mean(collectiveData_cov.allPeakHeights);
cov_heightMedian = median(collectiveData_cov.allPeakHeights);
cov_heightStd = std(collectiveData_cov.allPeakHeights);
cov_spacingXMean = mean(collectiveData_cov.allXSpacings); 
cov_spacingXMedian = median(collectiveData_cov.allXSpacings); 
cov_spacingXStd = std(collectiveData_cov.allXSpacings);
cov_spacingYMean = mean(collectiveData_cov.allYSpacings); 
cov_spacingYMedian = median(collectiveData_cov.allYSpacings);
cov_spacingYStd = std(collectiveData_cov.allYSpacings);
cov_angleMean = mean(collectiveData_cov.allAngles);  
cov_angleMedian = median(collectiveData_cov.allAngles);  
cov_angleStd = std(collectiveData_cov.allAngles);
cov_areaMean = mean(collectiveData_cov.allAreas);    
cov_areaMedian = median(collectiveData_cov.allAreas);  
cov_areaStd = std(collectiveData_cov.allAreas);
cov_volumeMean = mean(collectiveData_cov.allVolumes);       
cov_volumeMedian = median(collectiveData_cov.allVolumes);     
cov_volumeStd = std(collectiveData_cov.allVolumes);

%% ========================== Flagging ================================

% == Uncovered ==

[flagTable_unc,flagArray_unc] = flag_summary_stats(summaryStats_unc, collectiveData_unc);
% == Covered ==

[flagTable_cov,flagArray_cov] = flag_summary_stats(summaryStats_cov, collectiveData_cov);


% Uncovered
expectedPeaks = [1.45 2.85 4.25];%, 5.65]%, 7.05]; % mm
%expectedPeaks = [1.55 3.0 4.45]%, 5.95]%, 7.45];
baseTolerancePercent = 15; % percentage tolerance

numSamples = height(individualData_unc);
flags_scaled = zeros(numSamples,1); % initialize

for i = 1:numSamples
    xproj = individualData_unc{i,'xProj'}{1};
    
    % Skip very short arrays
    if numel(xproj) < 3
        flags_scaled(i) = NaN;
        continue;
    end
    
    % Detect peaks
    [detectedPeaks, ~] = findpeaks(xproj, ...
        'MinPeakDistance', 1, ...
        'MinPeakHeight', max(xproj)*0.1);
    
    % Check each expected peak with percentage-based tolerance
    matchCount = 0;
    for k = 1:length(expectedPeaks)
        tolerance = expectedPeaks(k) * (baseTolerancePercent/100);  
        if any(abs(detectedPeaks - expectedPeaks(k)) <= tolerance)
            matchCount = matchCount + 1;
        end
    end
    
    % Flag = 1 if all peaks detected, else 0
    if matchCount == length(expectedPeaks)
        flags_scaled(i) = 1;
    else
        flags_scaled(i) = 0;
    end
end

% Add scaled flags to table
individualData_unc.XFlag_Scaled = flags_scaled;
flagTable_unc.Flag_Xctc = individualData_unc.XFlag_Scaled;

% Count and percentage
numPass_scaled = sum(individualData_unc.XFlag_Scaled == 1);
totalSamples_scaled = sum(~isnan(individualData_unc.XFlag_Scaled));
percentPass_scaled = (numPass_scaled / totalSamples_scaled) * 100;

fprintf('Number of uncovered samples passing (percentage tolerance): %d out of %d (%.2f%%)\n', numPass_scaled, totalSamples_scaled, percentPass_scaled);

% Covered 
expectedPeaks = [1.55 2.95 4.35];%, 5.85]%, 7.75]; % mm
baseTolerancePercent = 15; % tolerance for first peak

numSamples = height(individualData_cov);
flags_scaled = zeros(numSamples,1); % initialize

for i = 1:numSamples
    xproj = individualData_cov{i,'xProj'}{1};
    
    % Skip very short arrays
    if numel(xproj) < 3
        flags_scaled(i) = NaN;
        continue;
    end
    
    % Detect peaks
    [detectedPeaks, ~] = findpeaks(xproj, ...
        'MinPeakDistance', 1, ...
        'MinPeakHeight', max(xproj)*0.1);
    
    % Check each expected peak with percentage-based tolerance
    matchCount = 0;
    for k = 1:length(expectedPeaks)
        tolerance = expectedPeaks(k) * (baseTolerancePercent/100);  
        if any(abs(detectedPeaks - expectedPeaks(k)) <= tolerance)
            matchCount = matchCount + 1;
        end
    end
    
    % Flag = 1 if all peaks detected, else 0
    if matchCount == length(expectedPeaks)
        flags_scaled(i) = 1;
    else
        flags_scaled(i) = 0;
    end
end

    % Add scaled flags to table
    individualData_cov.XFlag_Scaled = flags_scaled;
    flagTable_cov.Flag_Xctc = individualData_cov.XFlag_Scaled;
    
    % Count and percentage
    numPass_scaled = sum(individualData_cov.XFlag_Scaled == 1);
    totalSamples_scaled = sum(~isnan(individualData_cov.XFlag_Scaled));
    percentPass_scaled = (numPass_scaled / totalSamples_scaled) * 100;
    
    fprintf('Number of covered samples passing (percentage tolerance): %d out of %d (%.2f%%)\n', numPass_scaled, totalSamples_scaled, percentPass_scaled);
    
    %% Uncovered Flag graphs

    % === Use flagTable_unc to generate visualization ===
    statLabels = flagTable_unc.Properties.VariableNames(2:end);
    flagsNumeric = table2array(flagTable_unc(:, 2:end));
    numDatasets = size(flagsNumeric, 1);
    numStats = size(flagsNumeric, 2);
    
    % === Sort statistics by total flagged count (descending) ===
    [~, sortIdx] = sort(sum(flagsNumeric, 1), 'descend');
    flagsNumericSorted = flagsNumeric(:, sortIdx);
    statLabelsSorted = statLabels(sortIdx);

    passFraction_unc = sum(flagsNumeric, 1) / numDatasets
    
    % === Figure 1: Stacked Bar Chart of Flagged Stats per Dataset ===
    fig = figure('Units','normalized','OuterPosition',[0 0 1 1]);
    b = bar(flagsNumericSorted, 'stacked');
    % Custom bar colors
    customColors = [
        0.85 0.33 0.10;
        0.00 0.45 0.74;
        0.47 0.67 0.19;
        0.93 0.69 0.13;
        0.49 0.18 0.56;
    ];
    for i = 1:length(b)
        b(i).FaceColor = customColors(i,:);
    end
    ylab = ylabel('Criteria passed (1 = within criterion)','FontSize', 50);
    xlabel('Egg Mass Sample','FontSize', 50);
    xticks('');
    yticks('');
    xlim([0 numDatasets + 1])
    pbaspect([1.5 1 1])
    ylab.Position(1) = ylab.Position(1) - 3;
    ax = gca;
    ax.FontSize = 36;
    ax.LineWidth = 2;
    legend(statLabelsSorted, 'Interpreter', 'none', ...
            'Location', 'bestoutside', 'FontSize', 50);
    exportgraphics(fig, 'StackedFlag_unc.png', 'Resolution', 300);
    
    
    %% 
    % === Use flagTable_cov to generate visualization ===
    statLabels = flagTable_cov.Properties.VariableNames(2:end);
    flagsNumeric = table2array(flagTable_cov(:, 2:end));
    numDatasets = size(flagsNumeric, 1);
    numStats = size(flagsNumeric, 2);
    
    % === Sort statistics by total flagged count (descending) ===
    [~, sortIdx] = sort(sum(flagsNumeric, 1), 'descend')
    flagsNumericSorted = flagsNumeric(:, sortIdx);
    statLabelsSorted = statLabels(sortIdx);

    passFraction_cov = sum(flagsNumeric, 1) / numDatasets
    
    % === Figure 1: Stacked Bar Chart of Flagged Stats per Dataset ===
    fig = figure('Units','normalized','OuterPosition',[0 0 1 1]);
    b = bar(flagsNumericSorted, 'stacked');
    % Custom bar colors
    customColors = [
        0.85 0.33 0.10; 
        0.93 0.69 0.13;
        0.00 0.45 0.74;
        0.49 0.18 0.56;
        0.47 0.67 0.19;
    ];
    for i = 1:length(b)
        b(i).FaceColor = customColors(i,:);
    end
    ylab = ylabel('Criteria passed (1 = within criterion)','FontSize', 50);
    xlabel('Egg Mass Sample','FontSize', 50);
    xticks('');
    yticks('');
    xlim([0 numDatasets + 1])
    pbaspect([1.5 1 1])
    ylab.Position(1) = ylab.Position(1) - 1;
    ax = gca;
    ax.FontSize = 36;
    ax.LineWidth = 2;
    legend(statLabelsSorted, 'Interpreter', 'none', ...
            'Location', 'bestoutside', 'FontSize', 50);
    exportgraphics(fig, 'StackedFlag_cov.png', 'Resolution', 300);
