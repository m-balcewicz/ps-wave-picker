function [data, sampleRate, numChannels, meta] = loadData(filename, waveform_source)

    if nargin < 2 || isempty(waveform_source)
        waveform_source = 'vallen';
    end

    funcDir = fileparts(mfilename('fullpath'));
    projectRoot = fileparts(fileparts(funcDir));
    filepath = fullfile(projectRoot, 'data', filename);

    lines = readlines(filepath);

    reader = getWaveformSourceReader(waveform_source);
    compiler = getWaveformSourceCompiler(waveform_source);

    [data, meta] = reader(lines, filepath, filename);
    meta.waveformSource = waveform_source;
    meta = compiler(meta, data);

    sampleRate = meta.sampleRate;
    numChannels = meta.numChannels;

end
