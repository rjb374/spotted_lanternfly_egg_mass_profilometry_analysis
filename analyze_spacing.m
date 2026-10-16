function [xProj, yProj, normAngles, xPeak, yPeak] = analyze_spacing(coords)
    % ANALYZE_SPACING calculates pairwise distances and angles between points,
    % then analyzes their projected spacing distributions along X and Y axes.
    %
    % INPUT:
    %   coords     - Nx2 array of 2D coordinates [x, y], e.g., egg peak locations.
    %
    % OUTPUTS:
    %   xProj      - Vector of absolute projected distances along the X-axis.
    %   yProj      - Vector of absolute projected distances along the Y-axis.
    %   normAngles - Vector of normalized angles (degrees, modulo 180) between pairs.
    %   xPeak      - Scalar. Location (distance) of the dominant peak in X projections.
    %   yPeak      - Scalar. Location (distance) of the dominant peak in Y projections.
    %
    % DESCRIPTION:
    % Computes ordered pairwise vectors between points (both i->j and j->i),
    % derives their Euclidean
    % lengths and angles, then projects these lengths onto the X and Y axes.
    % Histograms of these projections identify dominant spacing distances, 

    num = size(coords,1);      % Number of points
    lengths = [];              % To store distances between pairs
    angles = [];               % To store angles between pairs

    % Compute pairwise vectors, lengths, and angles for every unique pair (i != j)
    for i = 1:num
        for j = 1:num
            if i ~= j
                vec = coords(j,:) - coords(i,:);             % Vector from i to j
                lengths(end+1) = norm(vec);                  % Euclidean distance ||vec||
                angles(end+1) = atan2d(vec(2), vec(1));      % Angle in degrees (-180 to 180)
            end
        end
    end

    % Convert angles to radians for trigonometric projection
    anglesRad = deg2rad(angles);

    % Project lengths onto X and Y axes (absolute values)
    xProj = abs(lengths .* cos(anglesRad));  % Length * cos(theta)
    yProj = abs(lengths .* sin(anglesRad));  % Length * sin(theta)

    % Normalize angles to [0, 180) degrees to ignore directionality
    normAngles = mod(angles, 180);

    % Histogram parameters
    binWidth = 0.1;
    
    % Compute histograms of projected distances
    [xCounts, xEdges] = histcounts(xProj, 'BinWidth', binWidth);
    [yCounts, yEdges] = histcounts(yProj, 'BinWidth', binWidth);
    
    % Calculate bin centers
    xCenters = (xEdges(1:end-1) + xEdges(2:end)) / 2;
    yCenters = (yEdges(1:end-1) + yEdges(2:end)) / 2;
    
    % Define the center to exclude
    excludeX = 0.05;
    excludeY = 0.05;
    
    % Mask out the excluded center (within tolerance)
    tol = 1e-6;  % Use small tolerance for floating-point comparison
    excludeMaskX = abs(xCenters - excludeX) < tol;
    excludeMaskY = abs(yCenters - excludeY) < tol;
    
    % Set excluded bin count to -Inf so it won't be picked
    xCounts(excludeMaskX) = -Inf;
    yCounts(excludeMaskY) = -Inf;
    
    % Find index of highest remaining bin
    [~, xIdx] = max(xCounts);
    [~, yIdx] = max(yCounts);
    
    % Get corresponding bin centers
    xPeak = xCenters(xIdx);
    yPeak = yCenters(yIdx);

end