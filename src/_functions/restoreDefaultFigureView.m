function restoreDefaultFigureView(fig)

    ax = findobj(fig, 'Type', 'axes');

    defaultXLim = getappdata(fig, 'DefaultXLim');
    defaultYLim = getappdata(fig, 'DefaultYLim');

    if ~isempty(defaultXLim)
        xlim(ax, defaultXLim);
    end

    if ~isempty(defaultYLim)
        ylim(ax, defaultYLim);
    end

    drawnow;

end