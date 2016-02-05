addpath(genpath('./gcca'),'-end');

n1Spikes = round(rand(1,700));
n2Spikes = round(rand(1,700));
n3Spikes = circshift(and(n1Spikes,n2Spikes),[0,1]);
n1Spikes = n1Spikes(2:end-1);
n2Spikes = n2Spikes(2:end-1);
n3Spikes = n3Spikes(2:end-1);
%n3Spikes = n3Spikes(randperm(length(n3Spikes)));

X = [n1Spikes+1;n2Spikes+1;n3Spikes+1];
GC1 = granger_causality(X,1);
A_B = GC1(1,2);
A_C = GC1(1,3);
B_A = GC1(2,1);
B_C = GC1(2,3);
C_A = GC1(3,1);
C_B = GC1(3,2);
