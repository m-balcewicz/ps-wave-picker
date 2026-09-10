function [data, meta] = readFlowWaveform(lines, filepath, filename)

    if isempty(lines)
        error('The file is empty.');
    end

    headerLine = strtrim(lines(1));
    headerTokens = split(headerLine, ',');
    if numel(headerTokens) < 2
        error('The flow file must contain a Time_s column and at least one channel column.');
    end

    channelNames = strtrim(headerTokens(2:end));
    channelIds = parseFlowChannelIds(channelNames);
    numChannels = numel(channelIds);

    dataRows = lines(2:end);
    dataRows = dataRows(strlength(strtrim(dataRows)) > 0);

    if isempty(dataRows)
        error('The flow file does not contain waveform samples.');
    end

    matrix = nan(numel(dataRows), numChannels + 1);
    validRowCount = 0;
    for rowIdx = 1:numel(dataRows)
        rowValues = sscanf(dataRows(rowIdx), '%f,');
        if isempty(rowValues)
            continue;
        end

        if numel(rowValues) ~= numChannels + 1
            error('Data row %d contains %d columns, expected %d.', rowIdx, numel(rowValues), numChannels + 1);
        end

        validRowCount = validRowCount + 1;
        matrix(validRowCount, :) = rowValues.';
    end

    matrix = matrix(1:validRowCount, :);

    time_s = matrix(:, 1);
    data = matrix(:, 2:end);

    meta = struct();
    meta.filepath = filepath;
    meta.filename = filename;
    meta.headerLines = string(headerLine);
    meta.channelNames = channelNames;
    meta.channelIds = channelIds;
    meta.numChannels = numChannels;
    meta.numSamples = size(data, 1);
    meta.dataRows = size(data, 1);
    meta.time_s = time_s;

end

function channelIds = parseFlowChannelIds(channelNames)
    channelIds = nan(numel(channelNames), 1);
    for idx = 1:numel(channelNames)
        token = regexp(char(channelNames(idx)), '^CH(\d+)$', 'tokens', 'once');
        if isempty(token)
            channelIds(idx) = idx;
        else
            channelIds(idx) = str2double(token{1});
        end
    end
    channelIds = channelIds(:).';
end
