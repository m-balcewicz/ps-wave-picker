close all; clear allvars; clc

%% 

addpath(fullfile(fileparts(mfilename('fullpath')), '_functions'));

filename = 'signals_flow_0.csv';
waveform_source = 'flow';
[data, ~, ~, meta] = loadData(filename, waveform_source);
printWaveformInfo(meta);

%% 
[~, baseName, ~] = fileparts(filename);
saveDir = fullfile(fileparts(fileparts(mfilename('fullpath'))), 'data');

sourceProcessor = getWaveformSourceProcessor(waveform_source);
[~, ~] = sourceProcessor(data, meta, filename, baseName, saveDir);
