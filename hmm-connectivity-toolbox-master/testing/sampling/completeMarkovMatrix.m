function markov_mat = completeMarkovMatrix(m)
         markov_mat = zeros(size(m,1), size(m,2)+1);
         markov_mat(:, 1:size(m,2)) = m;
         for i = 1:size(markov_mat,1)
             markov_mat(i, size(markov_mat, 2)) = 1 - sum(m(i, :));
         end
