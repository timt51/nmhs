function [x, fval, exitflag, output] = simulanneal(FUN, x0, Aineq, bineq, Aeq, beq, lb, ub, options, solverDataPath)
%SIMULANNEAL    finds a constrained minimum of a function of several variables.
%   ***************************************************
%   * A, b, Aeq, beq are not yet implemented *
%   ***************************************************
%   SIMULANNEAL attempts to solve problems of the form:
%       min F(X)  subject to:  LB <= X <= UB
%        X                     
%                              
%   This function is private to SIMULANNEALBND.
%

%   Copyright 2006 The MathWorks, Inc.

defaultopt = struct('AnnealingFcn', @annealingfast, ...
'TemperatureFcn', @temperatureexp, ...
'AcceptanceFcn', @acceptancesa, ...
'TolFun', 1e-6, ...
'StallIterLimit', '500*numberofvariables', ...
'MaxFunEvals', '3000*numberofvariables', ...
'TimeLimit', Inf, ...
'MaxIter', Inf, ...
'ObjectiveLimit', -Inf, ...
'Display', 'final', ...
'DisplayInterval', 10, ...
'HybridFcn', [], ...
'HybridInterval', 'end', ...
'PlotFcns', [], ...
'PlotInterval', 1, ...
'OutputFcns', [], ...
'InitialTemperature', 100, ...
'ReannealInterval', 100, ...
'DataType', 'double');

% If just 'defaults' passed in, return the default options in X
if nargin == 1 && nargout <= 1 && isequal(FUN,'defaults')
    x = defaultopt; % returns defaults for SA
    return
end

% Preprocess all inputs, validate options, find initial feaasible point,
% create solver data
[x,fval,exitflag,output,solverData,problem,options] = ...
    simulannealcommon(FUN,x0,Aineq, bineq, Aeq, beq, lb, ub,options,defaultopt);
% Solver may terminate in preprocessing phase
if exitflag < 0
    return;
end

if nargin >=10 % solver data saving requested
  %check if previous solverdata exists - if so, load it use that to "resume" the computation
  if exist(solverDataPath, 'file') == 2
    disp(['loading data from ', solverDataPath])
    load(solverDataPath, 'solverData');
  else
    disp('no previous data found: starting from scratch')
  end
  % Call saengine to do the actual algorithm
  solverData = saengine(solverData,problem,options,solverDataPath);
else
  % Call saengine to do the actual algorithm
  solverData = saengine(solverData,problem,options);
end


% Prepare output arguments
x(:) = solverData.bestx;
fval = solverData.bestfval;
exitflag = solverData.exitflag;
% Finish the output structure
output.iterations = solverData.iteration;
output.funccount = solverData.funccount;
output.temperature = solverData.temp;
output.totaltime = cputime - solverData.t0;
output.message = solverData.message;
