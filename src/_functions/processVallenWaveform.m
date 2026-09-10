function [picks, pickFile] = processVallenWaveform(data, meta, filename, baseName, saveDir)

    plotTimeUs = meta.plotTimeUs;
    triggerTimeUs = meta.triggerTimeUs;
    numChannels = meta.numChannels;
    channelIds = meta.channelIds;

    pPickMatrix = nan(numChannels, 4);
    sPickMatrix = nan(numChannels, 4);

    if ~exist(saveDir, 'dir')
        mkdir(saveDir);
    end

    for channelIdx = 1:numChannels
        channelId = channelIds(channelIdx);
        fprintf('--- Channel %d of %d (ID %d) ---\n', channelIdx, numChannels, channelId);

        [pPickMatrix(channelIdx, :), sPickMatrix(channelIdx, :), pickedWaveType] = processTraceChannel( ...
            plotTimeUs, data, channelIdx, channelId, filename, baseName, triggerTimeUs);

        if strcmp(pickedWaveType, 'skip') || isempty(pickedWaveType)
            fprintf('Trace skipped for channel ID %d.\n', channelId);
        elseif strcmp(pickedWaveType, 'P')
            fprintf('Picked P-wave arrival at %.6f us (sample %d)\n', pPickMatrix(channelIdx, 3), pPickMatrix(channelIdx, 4));
        else
            fprintf('Picked S-wave arrival at %.6f us (sample %d)\n', sPickMatrix(channelIdx, 3), sPickMatrix(channelIdx, 4));
        end

        fprintf('Advancing to next channel...\n');
    end

    picks = struct('P', pPickMatrix, 'S', sPickMatrix);
    pickFile = fullfile(saveDir, sprintf('%s_picks.mat', baseName));
    save(pickFile, 'picks', 'filename', 'meta');
    fprintf('Wave picks saved to %s\n', pickFile);

end
