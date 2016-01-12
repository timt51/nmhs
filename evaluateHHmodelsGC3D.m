A_Bmeans = zeros(11, 1);
A_Cmeans = zeros(11, 1);
B_Ameans = zeros(11, 1);
B_Cmeans = zeros(11, 1);
C_Ameans = zeros(11, 1);
C_Bmeans = zeros(11, 1);
numGsyns = 11;
numCases = 10;
tmax = 10000;
binSize = 2;

for i = 1:numGsyns
    A_Bs = zeros(numCases,1);
    A_Cs = zeros(numCases,1);
    B_As = zeros(numCases,1);
    B_Cs = zeros(numCases,1);
    C_As = zeros(numCases,1);
    C_Bs = zeros(numCases,1);
    for j = 1:numCases
        n1 = n1s{numCases*(i-1)+j};
        n2 = n2s{numCases*(i-1)+j};
        n3 = n3s{numCases*(i-1)+j};
        T = Ts{numCases*(i-1)+j};
        n1Spikes = countSpikes(n1, T, tmax, binSize); n1Spikes(n1Spikes > 3) = 3;
        n2Spikes = countSpikes(n2, T, tmax, binSize); n2Spikes(n2Spikes > 3) = 3;
        n3Spikes = countSpikes(n3, T, tmax, binSize); n3Spikes(n3Spikes > 3) = 3;
               
        X = [n1Spikes+1;n2Spikes+1;n3Spikes+1];
        GC1 = granger_causality(X,0);
        A_Bs(j) = GC1(1,2);
        A_Cs(j) = GC1(1,3);
        B_As(j) = GC1(2,1);
        B_Cs(j) = GC1(2,3);
        C_As(j) = GC1(3,1);
        C_Bs(j) = GC1(3,2);
    end

    A_Bmeans(i) = mean(A_Bs);
    A_Cmeans(i) = mean(A_Cs);
    B_Ameans(i) = mean(B_As);
    B_Cmeans(i) = mean(B_Cs);
    C_Ameans(i) = mean(C_As);
    C_Bmeans(i) = mean(C_Bs);
end

figure(5);
plot(linspace(0,1,11),C_Ameans,linspace(0,1,11),C_Bmeans);
ylim([0 1]);
legend('C listens to A', 'C listens to B');
xlabel('gsyn');
ylabel('Connectivity');
title('Neurons A & B Excite Neuron C');

figure(6);
plot(linspace(0,1,11),A_Bmeans,linspace(0,1,11),A_Cmeans);
ylim([0 1]);
legend('A listens to B', 'A listens to C');
xlabel('gsyn');
ylabel('Connectivity');
title('Neurons A & B Excite Neuron C');

figure(7);
plot(linspace(0,1,11),B_Ameans,linspace(0,1,11),B_Cmeans);
ylim([0 1]);
legend('B listens to A', 'B listens to C');
xlabel('gsyn');
ylabel('Connectivity');
title('Neurons A & B Excite Neuron C');