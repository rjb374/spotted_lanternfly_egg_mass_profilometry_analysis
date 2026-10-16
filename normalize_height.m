function [X, Y, normHeight, xycalibration] = normalize_height(heightData, metadata)
    % NORMALIZE_HEIGHT converts raw height data into a normalized height map.
    %
    % INPUT:
    %   heightData     - Cell array. Raw height values (read from CSV) 
    %         
    %   metadata       - 20x3 cell array. Contains experiment or capture settings.
    %                    Must include 'XY Calibration' and 'Minimum value'.
    %
    % OUTPUT:
    %   X, Y           - Meshgrid matrices in mm representing spatial dimensions.
    %   normHeight     - Matrix of height values normalized by subtracting a
    %                    fitted background plane and setting a minimum threshold.
    %   xycalibration  - Scalar value in µm/pixel, used to convert to mm scale.

    % Extract required instrument metadata.
    calibrationIdx = strcmp(metadata(:,1), 'XY Calibration');
    minHeightIdx = strcmp(metadata(:,1), 'Minimum value');
    if nnz(calibrationIdx) ~= 1 || nnz(minHeightIdx) ~= 1
        error('normalize_height:MissingMetadata', ...
            'Expected one XY Calibration and one Minimum value metadata entry.');
    end
    xycalibration = metadata{calibrationIdx, 2}; % micrometres/pixel
    minHeight = metadata{minHeightIdx, 2};       % height units from instrument (mm in supplied CSVs)

    if ~isnumeric(xycalibration) || ~isscalar(xycalibration) || xycalibration <= 0
        error('normalize_height:InvalidCalibration', 'XY Calibration must be a positive numeric scalar.');
    end
    if ~isnumeric(minHeight) || ~isscalar(minHeight)
        error('normalize_height:InvalidMinimum', 'Minimum value must be a numeric scalar.');
    end

    % Convert cell array to numeric matrix (convert each cell to double)
    numericData = cell2mat(cellfun(@double, heightData, 'UniformOutput', false));

    % Replace non-finite entries (NaN, Inf) with the minimum value
    numericData(~isfinite(numericData)) = minHeight;

    % Normalize by subtracting the minimum height
    numericData = numericData - minHeight;

    % Ensure the height map is taller than it is wide (transpose if needed)
    if size(numericData, 2) > size(numericData, 1)
        numericData = numericData';
    end

    % Generate spatial coordinate axes in millimeters
    [rows, cols] = size(numericData);
    x = linspace(0, xycalibration * cols / 1000, cols);  % convert to mm
    y = linspace(0, xycalibration * rows / 1000, rows);  % convert to mm
    [X, Y] = meshgrid(x, y);

    % === Background Plane Fitting ===
    % Fit a planar surface using the outer edge pixels of the height map.
    edgeZ = [numericData(1,:), numericData(end,:), numericData(:,1)', numericData(:,end)'];  % Z values
    edgeX = [X(1,:), X(end,:), X(:,1)', X(:,end)'];                                           % X positions
    edgeY = [Y(1,:), Y(end,:), Y(:,1)', Y(:,end)'];                                           % Y positions

    % Construct design matrix A for solving plane: Z = aX + bY + c
    A = [edgeX(:), edgeY(:), ones(numel(edgeX),1)];
    b = edgeZ(:);

    % Solve least-squares problem to get plane coefficients [a; b; c]
    coeffs = A \ b;

    % Recreate background plane using the solved coefficients
    Zplane = coeffs(1)*X + coeffs(2)*Y + coeffs(3);

    % Subtract plane from original to flatten the surface
    normHeight = numericData - (Zplane);

    % Re-zero minimum value
    normHeight = normHeight - min(normHeight(:));

    % Threshold to ignore background/low values (e.g., residual noise)
    normHeight(normHeight < 1.1) = 0;
end
