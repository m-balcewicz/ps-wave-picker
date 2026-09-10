function [pRow, sRow, pickedWaveType] = processTraceChannel( ...
    plotTimeUs, data, channelIdx, channelId, filename, baseName, triggerTimeUs)

    fig = plotFigure( ...
        plotTimeUs, ...
        data, ...
        channelIdx, ...
        sprintf('Channel %d (ID %d) - %s', channelIdx, channelId, filename), ...
        triggerTimeUs);

    [pickedWaveType, pickedTimeUs, pickedSampleIdx] = pickTraceArrival( ...
        fig, plotTimeUs, data, channelIdx);

    if isempty(pickedWaveType) || strcmp(pickedWaveType, 'skip')
        pRow = [1, channelId, NaN, NaN];
        sRow = [1, channelId, NaN, NaN];
        delete(fig);
        return
    end

    if strcmp(pickedWaveType, 'P')
        pRow = [1, channelId, pickedTimeUs, pickedSampleIdx];
        sRow = [1, channelId, NaN, NaN];
    else
        pRow = [1, channelId, NaN, NaN];
        sRow = [1, channelId, pickedTimeUs, pickedSampleIdx];
    end

    restoreDefaultFigureView(fig);
    addPickedWaveLegend(fig, pickedWaveType);
    outputName = sprintf('%s_ch%d.png', baseName, channelId);
    saveFigure(fig, outputName);
    delete(fig);

    fprintf('Figure saved to figures/%s\n', outputName);

end