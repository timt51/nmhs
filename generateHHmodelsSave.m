addpath('2015 12-26-15 one exc one mod XOR spike');
tmax = 10000;
samppersec = 1000;
numCases = 10;
[n1s, n2s, n3s, Ts] = generateHHmodels(tmax, samppersec, numCases);
save('XOR','n1s','n2s','n3s','Ts');