function new_model = permute2DHMM(optimValues, problem_data)
  global sa_trajectory;
%   OPTIMVALUES is a structure with the following fields:
%              x: current point
%           fval: function value at x
%          bestx: best point found so far
%       bestfval: function value at bestx
%    temperature: current temperature
%      iteration: current iteration
%      funccount: number of function evaluations
%             t0: start time
%              k: annealing parameter 'k'


% "distance" between old model and newly generated one should be proportional to the current temperature
  new_model = optimValues.x;
  
  for i = 1:floor(optimValues.temperature)+1
    new_model = neighbor(new_model);
  end

  idx = optimValues.iteration + 1;
  sa_trajectory(idx).x = optimValues.x;
  sa_trajectory(idx).fval = optimValues.fval;
  sa_trajectory(idx).bestx = optimValues.bestx;
  sa_trajectory(idx).bestfval = optimValues.bestfval;
  sa_trajectory(idx).temperature = optimValues.temperature;
  sa_trajectory(idx).funccount = optimValues.funccount;
  sa_trajectory(idx).iteration = optimValues.iteration;
  sa_trajectory(idx).time = cputime;
  sa_trajectory(idx).t0 = optimValues.t0;
  sa_trajectory(idx).k = optimValues.k;         
end

function new_model = neighbor(new_model)
  [tr1, tr2, em1, em2] = unpack2DHMM(new_model);
  states1 = size(tr1, 1);
  states2 = size(tr2, 1);
  emissions1 = size(em1, 1);
  emissions2 = size(em2, 1);
  
  num_vals = (states1*states1*states2) + (states2*states2*states1) + ...
             (states1*emissions1) + (states2*emissions2);



  %note that this method of random selection is far from perfect,
  %but it should do for now on the simple test case where s1=s2=e1=e2

  %randomly select a matrix to modify
  mat_idx = ceil(rand(1)*(states1+states2+2));

  %randomly change a value by x <- [-0.1, 0.1]
  delta = (rand(1)-0.5)/5.0; 

  if(mat_idx <= states2)
    idx1 = ceil(rand(1)*states1);
    idx2 = ceil(rand(1)*states1);
    tr1(idx1, idx2, mat_idx) = tr1(idx1, idx2, mat_idx) + delta;
    tr1 = squeezeMarkov(tr1);
  elseif (mat_idx <= states1+states2)
    idx1 = ceil(rand(1)*states2);
    idx2 = ceil(rand(1)*states2);
    tr2(idx1, idx2, mat_idx-states1) = tr2(idx1, idx2, mat_idx-states1) + delta;
    tr2 = squeezeMarkov(tr2);
  elseif (mat_idx == states1+states2+2)
    idx1 = ceil(rand(1)*states1);
    idx2 = ceil(rand(1)*emissions1);
    em1(idx1, idx2) = em1(idx1, idx2) + delta;
    em1 = squeezeMarkov(em1);
  else
    idx1 = ceil(rand(1)*states2);
    idx2 = ceil(rand(1)*emissions2);
    em2(idx1, idx2) = em2(idx1, idx2) + delta;
    em2 = squeezeMarkov(em2);
  end
  new_model = pack2DHMM(tr1, tr2, em1, em2);
end
