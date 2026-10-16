function [metadata, heightData] = load_egg_csv(filepath)
% LOAD_EGG_CSV Load metadata and height measurements from a KEYENCE CSV.
%
% INPUT
%   filepath - Path to a KEYENCE csv export.
%
% OUTPUTS
%   metadata   - First 20 rows and first 3 columns of instrument metadata.
%   heightData - Height measurements beginning at row 22.

    if ~isfile(filepath)
        error('load_egg_csv:FileNotFound', 'CSV file not found: %s', filepath);
    end

    rawData = readcell(filepath, 'Delimiter', ',');
    if size(rawData, 1) < 22 || size(rawData, 2) < 3
        error('load_egg_csv:UnexpectedFormat', ...
            'CSV does not match the expected KEYENCE layout: %s', filepath);
    end

    metadata = rawData(1:20, 1:3);
    heightData = rawData(22:end, :);
end
