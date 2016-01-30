A_Bmeans = zeros(11, 1);
A_Cmeans = zeros(11, 1);
B_Ameans = zeros(11, 1);
B_Cmeans = zeros(11, 1);
C_Ameans = zeros(11, 1);
C_Bmeans = zeros(11, 1);
numGsyns = 11;

for i = 1:numGsyns
    A_Bs = zeros(numCases,1);
    A_Cs = zeros(numCases,1);
    B_As = zeros(numCases,1);
    B_Cs = zeros(numCases,1);
    C_As = zeros(numCases,1);
    C_Bs = zeros(numCases,1);
    x = n1s((numGsyns-1)*(i-1)+1:(numGsyns-1)*i);
    y = n2s((numGsyns-1)*(i-1)+1:(numGsyns-1)*i);
    z = n3s((numGsyns-1)*(i-1)+1:(numGsyns-1)*i);
    w = Ts((numGsyns-1)*(i-1)+1:(numGsyns-1)*i);
    parfor (j = 1:numCases, 10)
        disp((numGsyns-1)*(i-1)+j);
        [A_Bs(j), A_Cs(j), B_As(j), B_Cs(j), C_As(j), C_Bs(j)] = ...
            nmhs3D(x{j}, y{j}, z{j}, w{j}, tmax, binSize,coef);
    end
    A_Bmeans(i) = mean(A_Bs);
    A_Cmeans(i) = mean(A_Cs);
    B_Ameans(i) = mean(B_As);
    B_Cmeans(i) = mean(B_Cs);
    C_Ameans(i) = mean(C_As);
    C_Bmeans(i) = mean(C_Bs);
end

figure(1);
plot(linspace(0,1,11),C_Ameans,linspace(0,1,11),C_Bmeans);
ylim([0 1]);
legend('C listens to A', 'C listens to B');
xlabel('gsyn');
ylabel('Connectivity');
title('Neurons A & B Excite Neuron C');
savefig(strcat(path,'/data_',num2str(tmax),'_',num2str(n1n2prob*10),'_n3'));

figure(2);
plot(linspace(0,1,11),A_Bmeans,linspace(0,1,11),A_Cmeans);
ylim([0 1]);
legend('A listens to B', 'A listens to C');
xlabel('gsyn');
ylabel('Connectivity');
title('Neurons A & B Excite Neuron C');
savefig(strcat(path,'/data_',num2str(tmax),'_',num2str(n1n2prob*10),'_n1'));

figure(3);
plot(linspace(0,1,11),B_Ameans,linspace(0,1,11),B_Cmeans);
ylim([0 1]);
legend('B listens to A', 'B listens to C');
xlabel('gsyn');
ylabel('Connectivity');
title('Neurons A & B Excite Neuron C');
savefig(strcat(path,'/data_',num2str(tmax),'_',num2str(n1n2prob*10),'_n2'));
