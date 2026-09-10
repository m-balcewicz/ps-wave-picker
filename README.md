# ps-wave-picker

Created: 2026-09-10
Language: MATLAB

## Overview

`ps-wave-picker` is an interactive MATLAB tool for browsing waveform traces channel-by-channel and manually picking `P`-wave or `S`-wave arrivals.

The script:

- loads waveform data from `./data/`
- opens one figure per channel
- lets you zoom before picking
- saves a PNG for each processed channel in `./figures/`
- saves the final picks as `*_picks.mat` in `./data/`

## Supported waveform sources

The script currently supports two input formats through the `waveform_source` setting in [src/main.m](src/main.m).

### 1. `vallen`

Use this for Vallen-style CSV files with a metadata header and a `[DATA]` section.

Expected characteristics:

- header lines contain metadata such as `SampleRate`, `Samples`, `SetsOnFile`, `PreTriggerSamples`, and `Channel:`
- waveform samples start after a `[DATA]` line
- each data row contains one sample across all channels

Example configuration in [src/main.m](src/main.m):

```matlab
filename = 'vallen_export.csv';
waveform_source = 'vallen';
```

### 2. `flow`

Use this for flow-style CSV files where the first column is time and the remaining columns are waveform channels.

Expected characteristics:

- first column must be `Time_s`
- remaining columns are channel names such as `CH1`, `CH2`, `CH24`
- each row contains one time sample and one amplitude value per listed channel

Example configuration in [src/main.m](src/main.m):

```matlab
filename = 'signals_flow_0.csv';
waveform_source = 'flow';
```

## How to use

### 1. Put the waveform file in `data/`

Copy your source CSV into [data](data).

### 2. Set the file name and source type

Open [src/main.m](src/main.m) and edit these two lines:

```matlab
filename = 'your_file.csv';
waveform_source = 'vallen';   % or 'flow'
```

### 3. Run the script

Run [src/main.m](src/main.m) from MATLAB or from the MATLAB integration in VS Code.

The script will:

- add the helper folder to the MATLAB path
- load and interpret the selected waveform source
- print waveform metadata in the MATLAB console
- open one interactive plot per channel

### 4. Pick arrivals in the figure window

For each channel figure:

- use the figure tools to zoom or inspect the waveform
- click `Pick P-wave` to place a `P` arrival
- click `Pick S-wave` to place an `S` arrival
- click `Skip` to leave the trace unpicked
- after pressing a pick button, left-click on the waveform to place the arrival
- right-click or any non-left click cancels the current pick action

Plot behavior:

- the y-axis is centered around `0 mV`
- the zero-amplitude level is consistent across the plot by using symmetric limits
- exported figures restore the default full view before saving
- the legend is placed in the upper-left corner

## Output files

### Pick file

After all channels are processed, the script saves:

```text
data/<base_name>_picks.mat
```

This MAT file contains:

- `picks.P`
- `picks.S`
- `filename`
- `meta`

### Figures

Each processed channel is exported as:

```text
figures/<base_name>_ch<channelId>.png
```

## Project structure

- [src/main.m](src/main.m): entrypoint script
- [src/_functions/loadData.m](src/_functions/loadData.m): source-dispatched loader
- [src/_functions/getWaveformSourceReader.m](src/_functions/getWaveformSourceReader.m): source reader registry
- [src/_functions/getWaveformSourceCompiler.m](src/_functions/getWaveformSourceCompiler.m): source compiler registry
- [src/_functions/getWaveformSourceProcessor.m](src/_functions/getWaveformSourceProcessor.m): source processor registry

## Notes

- If `waveform_source` is omitted in `loadData`, the default is `vallen`.
- The input file must exist in [data](data).
- Unsupported source names will raise an error.
