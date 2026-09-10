function fig = plotFigure(t, data, channel, plotTitle, triggerTimeUs)

    % Confirm that one waveform is selected.
    trace = data(:, channel);

    % Force both vectors to be columns.
    t = t(:);
    trace = trace(:);

    % Safety check: one time point per amplitude sample.
    if numel(t) ~= numel(trace)
        error('Time vector and selected waveform have different lengths.');
    end

    fig = figure( ...
        'Visible', 'on', ...
        'Color', 'w', ...
        'ToolBar', 'figure', ...
        'MenuBar', 'figure', ...
        'WindowStyle', 'normal', ...
        'DockControls', 'on', ...
        'NumberTitle', 'off', ...
        'Position', [100, 100, 1400, 700]);

    figure(fig);
    drawnow;
    shg;

    waveformLine = plot(t, trace, ...
        'Color', [0 0.4470 0.7410], ...
        'LineWidth', 0.5);
    set(waveformLine, 'Tag', 'WaveformLine');

    ax = gca;

    % Show the axes toolbar and unfold it by default (Expanded: R2026a+).
    ax.Toolbar.Visible = 'on';

    if isprop(ax.Toolbar, 'Expanded')
        ax.Toolbar.Expanded = "on";
    end

    % Set the axes properties.
    grid on;
    box on;

    xlabel('Time [\mus]');
    ylabel('Amplitude [mV]');
    title(plotTitle, 'Interpreter', 'none');

    xlim([t(1), t(end)]);

    maxAbsAmplitude = max(abs(trace));
    if maxAbsAmplitude <= 0 || isnan(maxAbsAmplitude)
        maxAbsAmplitude = 1;
    end

    yPadding = 0.05 * maxAbsAmplitude;
    ylim([-maxAbsAmplitude - yPadding, maxAbsAmplitude + yPadding]);
    yline(0, ':', 'Color', [0.35 0.35 0.35]);

    setappdata(fig, 'DefaultXLim', xlim(ax));
    setappdata(fig, 'DefaultYLim', ylim(ax));

    if nargin >= 5 && ~isempty(triggerTimeUs)
        triggerLine = xline(triggerTimeUs, '--k', 'Trigger', 'LabelVerticalAlignment', 'bottom');
        set(triggerLine, 'Tag', 'TriggerLine');
    end
end
