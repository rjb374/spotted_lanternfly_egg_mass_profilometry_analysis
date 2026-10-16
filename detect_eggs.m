function [eggCoords, peakHeights, numEggs] = detect_eggs(X, Y, Z, xyCalibration)
    % DETECT_EGGS Detects egg peaks in a height map using image processing.
    %
    % INPUTS:
    %   X, Y           - Meshgrid matrices of spatial coordinates (mm).
    %   Z              - Normalized height map matrix.
    %   xyCalibration  - Scalar. Calibration factor in micrometers per pixel.
    %
    % OUTPUTS:
    %   eggCoords      - Nx2 array. Real-world (X,Y) coordinates of detected eggs.
    %   peakHeights    - Nx1 vector. Height values at detected egg peaks.
    %   numEggs        - Scalar. Total number of eggs detected.
    %
    % PARAMETERS:
    %   mm_per_pixel   - Conversion factor from pixels to millimeters.
    %   minSpacing_mm  - Minimum allowed spacing between egg peaks (1.2 mm).
    %   minSpacing_px  - Minimum allowed spacing in pixels (derived from mm_per_pixel).

    % Convert calibration from µm/pixel to mm/pixel
    mm_per_pixel = xyCalibration / 1000;  

    % Set minimum spacing between detected peaks in mm and convert to pixels
    minSpacing_mm = 0.9;  
    minSpacing_px = minSpacing_mm / mm_per_pixel;

    % 1. Smooth the height map using Gaussian filter (sigma=3) to reduce noise
    Zsmooth = imgaussfilt(Z, 3);

    % 2. Find regional maxima as candidate egg peaks
    maximaMask = imregionalmax(Zsmooth);

    % 3. Apply watershed segmentation to separate peaks that are close together
    D = -Zsmooth;             % Invert height map for watershed (minima detection)
    D = imhmin(D, 1.5);       % Suppress shallow minima (<1.5 height units)
    L = watershed(D);          % Watershed transform labeling
    maximaMask(L == 0) = 0;   % Remove pixels on watershed boundaries from maxima

    % 4. Threshold the maxima by intensity using Otsu’s method scaled to max height
    threshold = graythresh(Zsmooth) * max(Zsmooth(:));  
    maximaMask(Zsmooth < threshold) = 0;  % Remove low-intensity peaks

    % 5. Label connected components in maxima mask (potential egg regions)
    [LabeledMask, ~] = bwlabel(maximaMask);

    % 6. Measure properties of labeled regions: area, centroid, max intensity, pixel indices
    stats = regionprops(LabeledMask, Zsmooth, ...
        'Area', 'Centroid', 'MaxIntensity', 'PixelIdxList');

    % 7. Enforce minimum spacing between peaks by iteratively removing close neighbors
    centroids = vertcat(stats.Centroid);
    selected = true(size(centroids,1),1);
    for i = 1:size(centroids,1)
        if ~selected(i)
            continue;  % Skip peaks already removed
        end
        distances = vecnorm(centroids - centroids(i,:), 2, 2);  % Euclidean distances
        closeIdx = find(distances < minSpacing_px & distances > 0);
        selected(closeIdx) = false;  % Remove peaks too close to the current one
    end
    stats = stats(selected);

    % 8. Convert centroid pixel positions to real-world mm coordinates
    eggCoords = zeros(length(stats), 2);
    peakHeights = zeros(length(stats), 1);
    for i = 1:length(stats)
        cx = round(stats(i).Centroid(1));  % X pixel coordinate
        cy = round(stats(i).Centroid(2));  % Y pixel coordinate
        eggCoords(i, :) = [X(1, cx), Y(cy, 1)];  % Spatial coordinates from meshgrid
        peakHeights(i) = Z(cy, cx);                % Height at detected peak
    end

    % 9. Total number of eggs detected
    numEggs = length(stats);
end
