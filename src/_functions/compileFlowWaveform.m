function meta = compileFlowWaveform(meta, data)

    if ~isfield(meta, 'time_s') || isempty(meta.time_s)
        error('Flow waveform metadata must include time_s.');
    end

    meta.sampleRate = 1 / median(diff(meta.time_s));
    meta.sampleIntervalUs = median(diff(meta.time_s)) * 1e6;
    meta.samplesPerChannel = size(data, 1);
    meta.setsOnFile = nan;
    meta.preTriggerSamples = 0;
    meta.timeStartUs = meta.time_s(1) * 1e6;
    meta.timeEndUs = meta.time_s(end) * 1e6;
    meta.durationMs = (meta.time_s(end) - meta.time_s(1)) * 1e3;
    meta.plotTimeUs = meta.time_s * 1e6;
    meta.triggerTimeUs = [];

end
