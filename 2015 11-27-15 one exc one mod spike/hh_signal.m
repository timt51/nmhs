% Leif Gibb 7/5/15 through 11/29/15

function [spike, n2spike] = hh_signal(timeline, samppersec, spikedur, spikefreq, signalrefrac, n1n2prob)

spikeprob = spikefreq / samppersec;
tspike = -spikedur-1;
n2tspike = -spikedur-1;
spike = zeros(size(timeline));
n2spike = zeros(size(timeline));
for t = timeline
    i = t+1;
    if t - tspike > signalrefrac && t - n2tspike > signalrefrac
        if rand < spikeprob
            tspike = tspike;
            tspike = t;
            if rand < n1n2prob
                n2tspike = n2tspike;
                n2tspike = t;
            end
        end
        if rand < spikeprob
            n2tspike = n2tspike;
            n2tspike = t;
            if rand < n1n2prob
                tspike = tspike;
                tspike = t;
            end
        end
    end
    if t - tspike <= spikedur
        spike(i) = 1;
    else
        spike(i) = 0;
    end
    if t - n2tspike <= spikedur
        n2spike(i) = 1;
    else
        n2spike(i) = 0;
    end
end

end