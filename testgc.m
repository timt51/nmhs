i=61;
tmax = 10000;
binSize = 2;

n1Spikes = countSpikes(n1s{i}, Ts{i}, tmax, binSize); n1Spikes(n1Spikes > 1) = 1;
n2Spikes = countSpikes(n2s{i}, Ts{i}, tmax, binSize); n2Spikes(n2Spikes > 1) = 1;
n3Spikes = countSpikes(n3s{i}, Ts{i}, tmax, binSize); n3Spikes(n3Spikes > 1) = 1;

disp(sum(n3Spikes)/sum(n1Spikes));

%figure(4);plot(Ts{95},n1s{95},Ts{95},n2s{95}+10,Ts{95},n3s{95}+20);xlim([1000 2000]);