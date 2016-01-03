function seq = convertSeq2DTo1D(seq1, seq2, e1, e2)
  states1 = size(e1, 1);
  emissions1 = size(e1, 2);
  states2 = size(e2, 1);
  emissions2 = size(e2, 2);         

  len_seq = length(seq1);
  
  num_emissions = emissions1*emissions2;
  seq = zeros(1, len_seq);

  %loop through rows
  for idx = 1:len_seq
      seq(idx) = seq1(idx) + (seq2(idx)-1)*emissions1;
  end
  
