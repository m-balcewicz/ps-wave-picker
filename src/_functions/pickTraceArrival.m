function [pickedWaveType, pickedTimeUs, pickedSampleIdx] = pickTraceArrival(fig, t_us, data, channel)

    figure(fig);
    ax = findobj(fig, 'Type', 'axes');

    % Leave extra top strip for controls so the axes title is not clipped.
    ax.Position = [0.08, 0.10, 0.88, 0.74];
    drawnow;
    pause(0.10);
    drawnow;

    % Navigation is enabled by default; picking starts only via button.
    zoom(fig, 'on');
    pan(fig, 'off');

    pickState = struct('waveType', '', 'timeUs', [], 'sampleIdx', []);
    setappdata(fig, 'PickState', pickState);

    delete(findall(fig, 'Type', 'uicontrol', 'Tag', 'WavePickerControl'));

    uicontrol(fig, 'Style', 'pushbutton', ...
        'Tag', 'WavePickerControl', ...
        'String', 'Pick P-wave', ...
        'Units', 'normalized', ...
        'Position', [0.02, 0.92, 0.13, 0.06], ...
        'FontWeight', 'bold', ...
        'Callback', @onPickP);

    uicontrol(fig, 'Style', 'pushbutton', ...
        'Tag', 'WavePickerControl', ...
        'String', 'Pick S-wave', ...
        'Units', 'normalized', ...
        'Position', [0.16, 0.92, 0.13, 0.06], ...
        'Callback', @onPickS);

    uicontrol(fig, 'Style', 'pushbutton', ...
        'Tag', 'WavePickerControl', ...
        'String', 'Skip', ...
        'Units', 'normalized', ...
        'Position', [0.30, 0.92, 0.08, 0.06], ...
        'Callback', @onSkip);

    uicontrol(fig, 'Style', 'text', ...
        'Tag', 'WavePickerControl', ...
        'String', 'Use zoom/pan with tools, then pick P-wave, S-wave, or Skip the trace.', ...
        'Units', 'normalized', ...
        'BackgroundColor', 'w', ...
        'HorizontalAlignment', 'left', ...
        'Position', [0.40, 0.92, 0.57, 0.06]);

    uiwait(fig);

    pickState = getappdata(fig, 'PickState');
    pickedWaveType = pickState.waveType;
    pickedTimeUs = pickState.timeUs;
    pickedSampleIdx = pickState.sampleIdx;

    function onPickP(~, ~)
        [pickedTimeUs, pickedSampleIdx] = pickPWaveArrival(fig, t_us, data, channel);
        if isempty(pickedTimeUs)
            return
        end

        pickState = getappdata(fig, 'PickState');
        pickState.waveType = 'P';
        pickState.timeUs = pickedTimeUs;
        pickState.sampleIdx = pickedSampleIdx;
        setappdata(fig, 'PickState', pickState);
        uiresume(fig);
    end

    function onPickS(~, ~)
        [pickedTimeUs, pickedSampleIdx] = pickSWaveArrival(fig, t_us, data, channel);
        if isempty(pickedTimeUs)
            return
        end

        pickState = getappdata(fig, 'PickState');
        pickState.waveType = 'S';
        pickState.timeUs = pickedTimeUs;
        pickState.sampleIdx = pickedSampleIdx;
        setappdata(fig, 'PickState', pickState);
        uiresume(fig);
    end

    function onSkip(~, ~)
        pickState = getappdata(fig, 'PickState');
        pickState.waveType = 'skip';
        pickState.timeUs = [];
        pickState.sampleIdx = [];
        setappdata(fig, 'PickState', pickState);
        uiresume(fig);
    end

end