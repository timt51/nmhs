addpath('2015 11-27-15 one exc one mod spike')
tmax = 10000;
samppersec = 1000;
numCases = 10;
[n1s, n2s, n3s, Ts] = generateHHmodels(tmax, samppersec, numCases);
save('AND');