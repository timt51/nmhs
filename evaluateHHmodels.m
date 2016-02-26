allC_As = {};
allA_Cs = {};
C_Ameans = zeros(11, 1);
A_Cmeans = zeros(11, 1);
numGsyns = 11;
numCases = 1;

for i = 1:numGsyns
    C_As = zeros(numCases,1);
    A_Cs = zeros(numCases,1);
    for j = 1:numCases
        disp(numCases*(i-1)+j);
        [C_A, A_C, logLs] = nmhs2D(n1s{numCases*(i-1)+j}, n2s{numCases*(i-1)+j}, n3s{numCases*(i-1)+j}, Ts{numCases*(i-1)+j}, tmax, 100);
        C_As(j) = C_A;
        A_Cs(j) = A_C;
    end
    allC_As{i} = C_As;
    allA_Cs{i} = A_Cs;
    C_Ameans(i) = mean(C_As);
    A_Cmeans(i) = mean(A_Cs);
end

plot(linspace(0,1,11),C_Ameans,linspace(0,1,11),A_Cmeans);
ylim([0 1]);
legend('B listens to A', 'A listens to B');
xlabel('gsyn');
ylabel('Connectivity');
title('Neuron A Excites Neuron B');