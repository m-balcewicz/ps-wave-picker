function [pickedTimeUs, pickedSampleIdx] = pickWaveArrival(fig, t_us, data, channel, markerColor)

    figure(fig);
    ax = findobj(fig, 'Type', 'axes');

    zoom(fig, 'off');
    pan(fig, 'off');

    [clickedTimeUs, ~, clickedButton] = ginput(1);
    if isempty(clickedTimeUs) || isempty(clickedButton) || clickedButton ~= 1
        pickedTimeUs = [];
        pickedSampleIdx = [];
        zoom(fig, 'on');
        return
    end

    trace = data(:, channel);
    [~, pickedSampleIdx] = min(abs(t_us - clickedTimeUs));
    pickedTimeUs = t_us(pickedSampleIdx);

    hold(ax, 'on');
        pickLine = xline(ax, pickedTimeUs, '--', 'Color', markerColor, 'LineWidth', 1.2);
        set(pickLine, 'Tag', 'PickedArrivalLine');

        pickMarker = plot(ax, pickedTimeUs, trace(pickedSampleIdx), 'o', ...
         'Color', markerColor, 'MarkerFaceColor', markerColor, 'MarkerSize', 7);
        set(pickMarker, 'Tag', 'PickedArrivalMarker');
    hold(ax, 'off');
    drawnow;

    zoom(fig, 'on');
    pan(fig, 'off');
end