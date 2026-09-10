function [pickedTimeUs, pickedSampleIdx] = pickSWaveArrival(fig, t_us, data, channel)

    [pickedTimeUs, pickedSampleIdx] = pickWaveArrival( ...
        fig, t_us, data, channel, [0.0000, 0.4470, 0.7410]);

end