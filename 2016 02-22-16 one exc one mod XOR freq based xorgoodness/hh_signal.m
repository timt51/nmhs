% Leif Gibb 7/5/15

function [phasic spike] = hh_signal(timeline, samppersec, spikedur, phasicdurmin, phasicdurmax, phasicspikefreqmin, phasicspikefreqmax, tonicdurmin, tonicdurmax, tonicspikefreqmin, tonicspikefreqmax)

phasicdurmean = mean([phasicdurmin phasicdurmax]);
tonicdurmean = mean([tonicdurmin tonicdurmax]);
phasic = rand < phasicdurmean / (phasicdurmean + tonicdurmean);
flag = false;
for t = timeline(2:end)
    if phasic(end)
        if ~flag
            phasicdur = phasicdurmin + (phasicdurmax - phasicdurmin)*rand;
            transprob = 1 / (phasicdur*samppersec);
            flag = true;
        end
        if rand < transprob
            phasic(end+1) = 0;
            flag = false;
        else
            phasic(end+1) = 1;
        end
    else
        if ~flag
            tonicdur = tonicdurmin + (tonicdurmax - tonicdurmin)*rand;
            transprob = 1 / (tonicdur*samppersec);
            flag = true;
        end
        if rand < transprob
            phasic(end+1) = 1;
            flag = false;
        else
            phasic(end+1) = 0;
        end
    end
end

tspike = -spikedur-1;
spike = zeros(size(timeline));
phasicflag = false;
tonicflag = false;
for t = timeline
    i = t+1;
    if phasic(i)
        if ~phasicflag
            spikefreq = phasicspikefreqmin + (phasicspikefreqmax - phasicspikefreqmin)*rand;
            spikeprob = spikefreq / samppersec;
            phasicflag = true;
            tonicflag = false;
        end
        if rand < spikeprob
            tspike = t;
        end
        if t - tspike <= spikedur
            spike(i) = 1;
        else
            spike(i) = 0;
        end
    else
        if ~tonicflag
            spikefreq = tonicspikefreqmin + (tonicspikefreqmax - tonicspikefreqmin)*rand;
            spikeprob = spikefreq / samppersec;
            tonicflag = true;
            phasicflag = false;
        end
        if rand < spikeprob
            tspike = t;
        end
        if t - tspike <= spikedur
            spike(i) = 1;
        else
            spike(i) = 0;
        end
    end
end

end