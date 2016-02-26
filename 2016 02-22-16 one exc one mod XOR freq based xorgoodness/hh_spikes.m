% Leif Gibb 2/20/16
% Based on hh_freq (Leif Gibb 7/9/15)

function spikes = hh_spikes(waveform, thresh)

spikes = false(size(waveform));

flag = false;
for i = 1:length(waveform)
    if ~flag
        if waveform(i) > thresh
            flag = true;
            spikes(i) = true;
        end
    else
        if waveform(i) <= thresh
            flag = false;
        end
    end
end

end