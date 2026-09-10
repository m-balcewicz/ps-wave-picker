function [data, meta] = readVallenWaveform(lines, filepath, filename)

    dataStartIdx = find(contains(lines, '[DATA]'), 1, 'first');
    if isempty(dataStartIdx)
        error('The file does not contain a [DATA] section.');
    end

    headerLines = lines(1:dataStartIdx - 1);
    dataLines = lines(dataStartIdx + 1:end);

    headerChannelLine = find(contains(headerLines, 'Channel:'), 1, 'first');
    numChannels = numel(regexp(char(headerLines(headerChannelLine)), 'Channel:\s*\d+', 'match'));

    sampleRateLine = find(contains(headerLines, 'SampleRate'), 1, 'first');
    samplesLine = find(contains(headerLines, 'Samples:'), 1, 'first');
    setsOnFileLine = find(contains(headerLines, 'SetsOnFile:'), 1, 'first');
    preTriggerLine = find(contains(headerLines, 'PreTriggerSamples:'), 1, 'first');
    channelLine = headerChannelLine;

    sampleRate = parseFirstNumber(headerLines(sampleRateLine));
    samplesPerChannel = parseFirstNumber(headerLines(samplesLine));
    setsOnFile = parseFirstNumber(headerLines(setsOnFileLine));
    preTriggerSamples = parseFirstNumber(headerLines(preTriggerLine));
    channelIds = parseNumberList(headerLines(channelLine));

    dataLines = dataLines(strlength(strtrim(dataLines)) > 0);
    data = nan(numel(dataLines), numChannels);
    validRowCount = 0;
    for rowIdx = 1:numel(dataLines)
        rowValues = sscanf(dataLines(rowIdx), '%f,');
        if isempty(rowValues)
            continue;
        end

        if numel(rowValues) ~= numChannels
            error('Data row %d contains %d columns, expected %d.', rowIdx, numel(rowValues), numChannels);
        end
        validRowCount = validRowCount + 1;
        data(validRowCount, :) = rowValues.';
    end

    data = data(1:validRowCount, :);

    if isempty(samplesPerChannel)
        samplesPerChannel = size(data, 1);
    end

    if isempty(preTriggerSamples)
        preTriggerSamples = 0;
    end

    meta = struct();
    meta.filepath = filepath;
    meta.filename = filename;
    meta.headerLines = headerLines;
    meta.sampleRate = sampleRate;
    meta.samplesPerChannel = samplesPerChannel;
    meta.setsOnFile = setsOnFile;
    meta.preTriggerSamples = preTriggerSamples;
    meta.channelIds = channelIds;
    meta.numChannels = numChannels;
    meta.numSamples = size(data, 1);
    meta.dataRows = size(data, 1);

    if size(data, 1) ~= samplesPerChannel
        warning('Header reports %d samples, but %d data rows were read.', samplesPerChannel, size(data, 1));
    end

end

function value = parseFirstNumber(textLine)
    token = regexp(char(textLine), '[-+]?(?:\d*\.\d+|\d+)(?:[eE][-+]?\d+)?', 'match', 'once');
    if isempty(token)
        value = nan;
    else
        value = str2double(token);
    end
end

function values = parseNumberList(textLine)
    tokens = regexp(char(textLine), '[-+]?(?:\d*\.\d+|\d+)(?:[eE][-+]?\d+)?', 'match');
    values = str2double(tokens);
end
