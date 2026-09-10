function [pickedTimeUs, pickedSampleIdx] = pickPWaveArrival(fig, t_us, data, channel)

    [pickedTimeUs, pickedSampleIdx] = pickWaveArrival( ...
        fig, t_us, data, channel, [0.8500, 0.3250, 0.0980]);

end