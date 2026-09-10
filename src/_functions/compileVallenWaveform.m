function meta = compileVallenWaveform(meta, data)

    meta.sampleIntervalUs = 1e6 / meta.sampleRate;
    meta.timeStartUs = 0;
    meta.timeEndUs = (size(data, 1) - 1) / meta.sampleRate * 1e6;
    meta.durationMs = (size(data, 1) - 1) / meta.sampleRate * 1e3;
    meta.plotTimeUs = (0:size(data, 1)-1).' / meta.sampleRate * 1e6;
    meta.triggerTimeUs = meta.preTriggerSamples / meta.sampleRate * 1e6;

end