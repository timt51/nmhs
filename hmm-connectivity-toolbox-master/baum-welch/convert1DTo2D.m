function [tr1, tr2, em1, em2] = convert2DTo1D(tr, em, dims)
  states1 = dims(1);
  emissions1 = dims(2);
  states2 = dims(3);
  emissions2 = dims(4);

  if(size(tr, 1) != states1*states2)
    disp("ERROR: state size mismatch");
    return;
  end
  num_emissions = emissions1*emissions2;
  tr = zeros(num_states, num_states);
  em = zeros(num_states, num_emissions);
  %loop through rows
  for s1 = 1:states1
    for s2 = 1:states2
        cs = s1 + (s2-1)*states1;
      % loop through columns now
      for e1 = 1:emissions1
        for e2 = 1:emissions2
          ce = e1 + (e2-1)*emissions1;
            em(cs, ce) =  em1(s1,e1)*em2(s2,e2);
        end
      end
      for ts1 = 1:states1
        for ts2 = 1:states2
            cts = ts1 + (ts2-1)*states1;
            tr(cs, cts) =  tr1(s1, ts1, s2) * tr2(s2, ts2, s1);
        end
      end
    end
  end
  
