% best2DestimateOf3D
% Given a 3D hmm data stream, trains the best possible 2D models between each pair of data streams.
function [logLs, models] = best2DestimateOf3D(packed_3D_model, data)
  [tr1, tr2, tr3, em1, em2, em3] = unpack3DHMM(packed_3D_model);
  num_states1 = size(tr1, 1);
  num_emissions1 = size(em1, 2);
  num_states2 = size(tr2, 1);
  num_emissions2 = size(em2, 2);  
  num_states3 = size(tr3, 1);
  num_emissions3 = size(em3, 2);  

  logLs = containers.Map();
  models = containers.Map();  
  
  %calculate ab
  [logL, tr1_trained, tr2_trained, em1_trained, em2_trained] =  ...
  best2Destimate(num_states1, num_states2, num_emissions1, num_emissions2, data{1}, data{2});
  models('tr1-tr2') = pack2DHMM(tr1_trained, tr2_trained, em1_trained, em2_trained);
  logLs('tr1-tr2') = logL;
  
  %calculate bc
  [logL, tr2_trained, tr3_trained, em2_trained, em3_trained] = ...
  best2Destimate(num_states2, num_states3, num_emissions2, num_emissions3, data{2}, data{3});
  models('tr2-tr3') = pack2DHMM(tr2_trained, tr3_trained, em2_trained, em3_trained);
  logLs('tr2-tr3') = logL;
  
  %calculate ac
  [logL, tr1_trained, tr3_trained, em1_trained, em3_trained] = ...
  best2Destimate(num_states1, num_states3, num_emissions1, num_emissions3, data{1}, data{3});
  models('tr1-tr3') = pack2DHMM(tr1_trained, tr3_trained, em1_trained, em3_trained);
  logLs('tr1-tr3') = logL;
         
