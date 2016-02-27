allC_As = {};
allA_Cs = {};
C_Ameans = zeros(11, 1);
A_Cmeans = zeros(11, 1);
numGsyns = 11;
numCases = 10;
tmax = 10000;

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

% plot(linspace(0,1,11),C_Ameans,linspace(0,1,11),A_Cmeans);
combined = bsxfun(@max,C_Ameans,A_Cmeans);
plot(linspace(0,1,11),combined);
ylim([0 1]);
% legend('B listens to A', 'A listens to B');
xlabel('gsyn of B');
ylabel('Maximum Connectivity Found With 2D Model');
title('Neuron A and B Excites Neuron C (2D Analysis)');