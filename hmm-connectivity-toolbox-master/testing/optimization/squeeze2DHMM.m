function [tr1, tr2, em1, em2] = squeeze2DHMM(tr1, tr2, em1, em2)
         % first squeezes values to be valid probabilities: x <- (0,1)
         % next makes sure all rows satisfy the markov bound
         tr1(tr1 > 1) = 1;
         tr2(tr2 > 1) = 1;
         em1(em1 > 1) = 1;
         em2(em2 > 1) = 1;
         tr1(tr1 < 0) = 0;
         tr2(tr2 < 0) = 0;
         em1(em1 < 0) = 0;
         em2(em2 < 0) = 0;                  
         tr1 = bsxfun(@rdivide, tr1, sum(tr1, 2));
         tr2 = bsxfun(@rdivide, tr2, sum(tr2, 2));
         em1 = bsxfun(@rdivide, em1, sum(em1, 2));
         em2 = bsxfun(@rdivide, em2, sum(em2, 2));         
