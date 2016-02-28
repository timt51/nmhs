means = zeros(21, 1);
stds = zeros(21,1);
numGsyns = 21;
numCases = 10;
tmax = 50000;

for i = 1:numGsyns
    connectivities = zeros(numCases,1);
    for j = 1:numCases
        disp(numCases*(i-1)+j);
        [C_A, A_C, logLs] = nmhs2D(n1s{numCases*(i-1)+j}, n2s{numCases*(i-1)+j}, n3s{numCases*(i-1)+j}, Ts{numCases*(i-1)+j}, tmax, 100);
        connectivities(j) = max(C_A,A_C);
    end
    means(i) = mean(connectivities);
    stds(i) = std(connectivities);
end

% plot(linspace(0,1,11),C_Ameans,linspace(0,1,11),A_Cmeans);
errorbar(linspace(0,2,21),means,stds);
xlim([0 2]); ylim([0 1]);
% legend('B listens to A', 'A listens to B');
xlabel('gsyn of B (gsyn of A = 0.5)');
ylabel('Maximum Connectivity Found With 2D Model');
title('Neurons A and B Excites Neuron C (2D Analysis)');