% Parameters
% Generate/Load HH models
tmax = 10000;
samppersec = 1000;
binSize = 2;
numCases = 10;
n1n2prob = 0.3;
binSize = 2;
coef = 1.475;
% Model Type
model = 'AND';
dim = 3;

% Initialize HMM and GC libraries
addpath(genpath('./hmm-connectivity-toolbox-master'),'-end');
addpath(genpath('./gcca'),'-end');

% Type of model
if strcmp(model,'2D Exec')
    path = './EXC EXC hh functions';
    addpath('./EXC EXC hh functions','-end');
elseif strcmp(model,'2D Osc')
    path = './2015 08-10-15 one exc oscillation';
    addpath('./2015 08-10-15 one exc oscillation','-end');
elseif strcmp(model,'AND')
    path = './2015 11-27-15 one exc one mod spike';
    addpath('./2015 11-27-15 one exc one mod spike','-end');
elseif strcmp(model,'XOR')
    path = './2015 12-26-15 one exc one mod XOR spike';
    addpath('./2015 12-26-15 one exc one mod XOR spike','-end');
else
    disp('Unknown model');
end

files = dir(strcat(path,'/*.mat'));
loaded = false;
for file = files'
    if strcmp(file.name,strcat('data_',num2str(tmax),'_',num2str(n1n2prob*10),'.mat'))
        load(strcat(path,'/',files(1).name));
        loaded = true;
    end
end

if loaded == false
   [n1s,n2s,n3s,Ts] = generateHHmodels(tmax,samppersec,numCases,n1n2prob);
   save(strcat(path,'/data_',num2str(tmax),'_',num2str(n1n2prob*10),'.mat'),'n1s','n2s','n3s','Ts');
end

if dim == 2
    evaluateHHmodels
elseif dim == 3
    evaluateHHmodels3D
end