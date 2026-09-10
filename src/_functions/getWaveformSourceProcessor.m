function processor = getWaveformSourceProcessor(waveform_source)

    switch lower(waveform_source)
        case 'vallen'
            processor = @processVallenWaveform;
        case 'flow'
            processor = @processFlowWaveform;
        otherwise
            error('Unsupported waveform source: %s', waveform_source);
    end

end
