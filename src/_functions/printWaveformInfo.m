function printWaveformInfo(meta)

    fprintf('--- Waveform information ---\n');
    if isfield(meta, 'waveformSource')
        fprintf('Source: %s\n', meta.waveformSource);
    end
    fprintf('File: %s\n', meta.filename);
    fprintf('Path: %s\n', meta.filepath);
    fprintf('Sample rate: %.12g Hz\n', meta.sampleRate);
    fprintf('Sampling interval: %.6f us\n', meta.sampleIntervalUs);
    fprintf('Samples per channel: %d\n', meta.samplesPerChannel);
    fprintf('Data rows read: %d\n', meta.dataRows);
    fprintf('Number of channels: %d\n', meta.numChannels);
    fprintf('Sets on file: %d\n', meta.setsOnFile);
    fprintf('Pre-trigger samples: %d\n', meta.preTriggerSamples);
    fprintf('Time span from first sample: %.6f us to %.6f us\n', meta.timeStartUs, meta.timeEndUs);
    fprintf('Trigger time from first sample: %.6f us\n', meta.triggerTimeUs);
    fprintf('Record duration: %.6f ms\n', meta.durationMs);

    if ~isempty(meta.channelIds)
        fprintf('Channel ids: ');
        fprintf('%d ', meta.channelIds);
        fprintf('\n');
    end

    fprintf('--- Raw header ---\n');
    for lineIdx = 1:numel(meta.headerLines)
        fprintf('%s\n', meta.headerLines(lineIdx));
    end
    fprintf('------------------------\n');

end