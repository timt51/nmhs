% Leif Gibb 7/9/15

function [spikecount, freq] = hh_freq(waveform, dur, thresh)

spikecount = 0;
flag = false;
for i = 1:length(waveform)
    if ~flag
        if waveform(i) > thresh
            flag = true;
            spikecount = spikecount + 1;
        end
    else
        if waveform(i) <= thresh
            flag = false;
        end
    end
end
freq = 1000*spikecount/dur;

end