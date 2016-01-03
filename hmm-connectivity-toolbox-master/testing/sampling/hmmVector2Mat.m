function [t, em] = hmmVector2Mat(vec, dims)
         t_inc_size = dims('states') * (dims('states')-1) * dims('neighbor_states');
         t_inc = reshape(vec(1:t_inc_size), dims('states'), dims('states') -1, dims('neighbor_states'));
         e_size = dims('states') * (dims('emissions') - 1);
         e_inc = reshape(vec(t_inc_size+1:size(vec,1)), dims('states'), dims('emissions') -1);
         t = zeros(dims('states'), dims('states'), dims('neighbor_states'));
         em = zeros(dims('states'), dims('emissions'));
         em = completeMarkovMatrix(e_inc);
         for j = 1:size(t, 3)
             t(:,:, j) = completeMarkovMatrix(t_inc(:,:,j));
         end
