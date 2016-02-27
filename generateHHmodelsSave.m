addpath('./EXC EXC hh functions','-end');
tmax = 10000;
samppersec = 1000;
numCases = 10;
[n1s, n2s, n3s, Ts] = generateHHmodels(tmax, samppersec, numCases);
save('EXC EXC Varying n2gsyn','n1s','n2s','n3s','Ts');