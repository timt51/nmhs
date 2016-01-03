function log_l = hmmLogL3D(packed_hmm, data)
  [~,~,s] = forward_backward3d(packed_hmm, data{1}, data{2}, data{3});
  log_l = sum(log(s));
