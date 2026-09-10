function reader = getWaveformSourceReader(waveform_source)

    switch lower(waveform_source)
        case 'vallen'
            reader = @readVallenWaveform;
        case 'flow'
            reader = @readFlowWaveform;
        otherwise
            error('Unsupported waveform source: %s', waveform_source);
    end

end
