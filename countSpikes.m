function spikes = countSpikes(voltage, T, tmax, binsize)
    spikes = zeros(1, floor(tmax/binsize) + 1);
    phase = 0;
    for i=1:length(voltage)
        if phase == 0
            if voltage(i) >= 70
                binno = floor(T(i)/binsize)+1;
                spikes(binno) = spikes(binno)+1;
                phase = 1;
            end
        else
            if voltage(i) < 70
                phase = 0;
            end
        end
    end
end