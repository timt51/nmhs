C_Ameans = zeros(11, 1);
A_Cmeans = zeros(11, 1);
numGsyns = 11;
numCases = 10;

for i = 1:numGsyns
    C_As = zeros(numCases,1);
    A_Cs = zeros(numCases,1);
    for j = 1:numCases
        n1 = n1s{numCases*(i-1)+j};
        n3 = n3s{numCases*(i-1)+j};
        T = Ts{numCases*(i-1)+j};
        n1Spikes = countSpikes(n1, T, 25000, 4); %n1Spikes(n1Spikes > 3) = 3;
        n3Spikes = countSpikes(n3, T, 25000, 4); %n3Spikes(n3Spikes > 3) = 3;
                
        X = [n1Spikes+1;n3Spikes+1];
        GC1 = granger_causality(X,0);
        C_As(j) = GC1(2,1);
        A_Cs(j) = GC1(1,2);
    end
    C_Ameans(i) = mean(C_As);
    A_Cmeans(i) = mean(A_Cs);
end

figure(5);
plot(linspace(0,1,11),C_Ameans,linspace(0,1,11),A_Cmeans);
ylim([0 1]);
legend('B listens to A', 'A listens to B');
xlabel('gsyn');
ylabel('Connectivity');
title('Neuron A Oscillates, Excites Neuron B');