# Egg Mass Surface Analysis

MATLAB code and supporting KEYENCE VR-series CSV height-map data used to quantify egg-mass surface structure for the associated manuscript.

## Repository contents

- `Full_analysis.m` — main analysis and figure-generation script.
- `Output_data.m` — processes all CSV files in one folder and aggregates sample-level and population-level results.
- `load_egg_csv.m` — reads KEYENCE metadata and height data from each CSV.
- `normalize_height.m` — converts the height map to spatial coordinates, removes a fitted background plane, and thresholds residual background.
- `detect_eggs.m` — detects individual egg peaks from the normalized height map.
- `analyze_spacing.m` — calculates pairwise X/Y projected spacing and orientation metrics.
- `calculateAreaVolume.m` — estimates egg-mass footprint area and volume.
- `collect_stats.m` — assembles sample summary statistics.
- `flag_summary_stats.m` — flags sample metrics relative to population mean +/- 1 SD.
- `Egg uncovered/` — 125 source CSV height maps for uncovered egg masses.
- `Egg covered/` — 58 source CSV height maps for covered egg masses.
- `Egg_uncovered_data.mat`, `Egg_covered_data.mat` — cached processed outputs supplied for convenience. The main script can rebuild these from the CSV files.

## Requirements

The analysis was written for MATLAB and uses functions from:

- MATLAB
- Image Processing Toolbox (`imgaussfilt`, `imregionalmax`, `imhmin`, `watershed`, `graythresh`, `bwlabel`, `regionprops`)
- Signal Processing Toolbox (`findpeaks`)

## Running the analysis

1. Clone or download this repository.
2. Open MATLAB and set the current folder to the repository root (the folder containing `Full_analysis.m`).
3. Open `Full_analysis.m`.
4. Set `rebuildFromCSV` near the top of the script:
   - `true` (recommended for reproducibility): reprocess all source CSV files and overwrite the cached `.mat` files.
   - `false`: load the supplied cached `.mat` files when available.
5. Run `Full_analysis.m`.

The script generates summary variables in the MATLAB workspace and exports the analysis figures as PNG files in the repository root. Generated PNGs are excluded by `.gitignore` so that running the analysis does not create untracked figure files.

## Input data format

Each source CSV is a KEYENCE VR-6000 export. The loader expects:

- metadata in rows 1-20;
- a header row at row 21;
- height measurements beginning at row 22;
- metadata entries named `XY Calibration` and `Minimum value`;
- height values in micommetres and XY calibration in micrometres per pixel, as supplied by the instrument export.

The CSV filenames identify individual samples. Treatment is determined by the parent folder (`Egg uncovered` or `Egg covered`).

## Analysis overview

For each CSV, the workflow is:

1. Read metadata and the height map.
2. Convert XY coordinates to millimetres and flatten the height map by fitting a plane to edge pixels.
3. Remove residual background below the analysis threshold.
4. Smooth the normalized height map and detect candidate egg peaks using regional maxima, watershed segmentation, intensity thresholding, and a minimum inter-peak spacing.
5. Calculate pairwise projected X/Y spacings and orientation angles between detected egg coordinates.
6. Calculate the positive-height footprint area and integrated volume.
7. Aggregate sample-level and treatment-level summary statistics.
8. Generate comparison plots and sample-level flags used in the analysis.

## Reproducibility notes

- The main script now exposes whether cached `.mat` data are used or rebuilt from the source CSVs. Rebuilding from CSV is the recommended archival workflow.
- macOS metadata and generated figures are excluded from version control.
- No machine-specific absolute file paths are required.

## Citation

Add citation when published
