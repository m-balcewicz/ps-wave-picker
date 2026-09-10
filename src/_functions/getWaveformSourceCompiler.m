function compiler = getWaveformSourceCompiler(waveform_source)

    switch lower(waveform_source)
        case 'vallen'
            compiler = @compileVallenWaveform;
        case 'flow'
            compiler = @compileFlowWaveform;
        otherwise
            error('Unsupported waveform source: %s', waveform_source);
    end

end
