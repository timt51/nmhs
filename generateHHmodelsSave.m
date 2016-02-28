addpath('./EXC EXC hh functions','-end');
tmax = 50000;
samppersec = 1000;
numCases = 10;
n2gsyn = 1.1;
[n1s, n2s, n3s, Ts] = generateHHmodels(tmax, samppersec, numCases, n2gsyn);
save('EXC_EXC_n2gsyn_11','n1s','n2s','n3s','Ts');