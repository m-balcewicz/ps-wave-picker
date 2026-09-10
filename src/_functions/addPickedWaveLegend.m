function addPickedWaveLegend(fig, pickedWaveType)

    ax = findobj(fig, 'Type', 'axes');

    waveformLine = findobj(ax, 'Type', 'line', 'Tag', 'WaveformLine');
    pickMarker = findobj(ax, 'Type', 'line', 'Tag', 'PickedArrivalMarker');

    if isempty(waveformLine) || isempty(pickMarker)
        return
    end

    if strcmp(pickedWaveType, 'P')
        pickLabel = 'P-wave pick';
    else
        pickLabel = 'S-wave pick';
    end

    set(waveformLine, 'DisplayName', 'Waveform');
    set(pickMarker, 'DisplayName', pickLabel);

    legend(ax, [waveformLine, pickMarker], ...
        'Location', 'northwest', ...
        'Interpreter', 'none', ...
        'AutoUpdate', 'off');

end