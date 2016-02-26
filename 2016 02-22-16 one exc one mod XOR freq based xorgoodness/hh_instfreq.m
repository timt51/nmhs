% Leif Gibb 2/20/16 and 2/22/16
% instfreq is in Hz

function instfreq = hh_instfreq(spikes, timeline)

if length(timeline) ~= length(spikes)
    error('length(timeline) ~= length(spikes)')
end

spiketimes = timeline(spikes);
ISIstarttimes = spiketimes(1:end-1);
ISIendtimes = spiketimes(2:end);
ISIs = ISIendtimes - ISIstarttimes;
instfreqs = 1000./ISIs;

instfreq = zeros(size(timeline));
for i = 1:length(timeline)
    for j = 1:length(instfreqs)
        if timeline(i) >= ISIstarttimes(j) && timeline(i) <= ISIendtimes(j)
            instfreq(i) = instfreqs(j); 
        end
    end
end

end