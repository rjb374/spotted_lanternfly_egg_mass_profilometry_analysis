function [massArea, massVolume] = calculateAreaVolume(normalizedHeightData, xyCalibration)
    % CALCULATEAREAVOLUME computes the surface area and volume of an egg mass.
    %
    % INPUTS:
    %   normalizedHeightData - 2D matrix. Height map after background normalization,
    %                          with height values in the same units as calibration.
    %   xyCalibration       - Scalar. Spatial calibration in micrometers per pixel (µm/pixel).
    %
    % OUTPUTS:
    %   massArea            - Scalar. Estimated surface area of egg mass in mm².
    %   massVolume          - Scalar. Estimated volume under the height map in mm³.
    %
    % DESCRIPTION:
    % Uses a simple threshold (height > 0) to create a mask of the egg mass area.
    % Area is calculated by counting mask pixels and multiplying by pixel area.
    % Volume is calculated by summing heights (only where mask is true) multiplied
    % by pixel area, effectively integrating height over the masked region.

    % Create a binary mask of pixels with positive height values (egg mass presence)
    binaryMask = normalizedHeightData > 0;

    % Calculate area of one pixel in mm² (convert calibration from µm to mm)
    pixelArea = (xyCalibration / 1000)^2;

    % Compute total area: count of positive pixels × pixel area
    massArea = sum(binaryMask(:)) * pixelArea;

    % Compute volume: sum of all positive height values × pixel area (height × area)
    massVolume = sum(normalizedHeightData(binaryMask)) * pixelArea;
end