%given vector representation of some HMM and an axis along which to interpolate
%within the multidimensional space, computes the upper and lower scalar bounds
%based on satisfying the markov property without any negative numbers
function [mn, mx] = scalarBounds(vec, dims, axis)
  %there are dims('states') markov matrices in the 2dhmm and then one more for
  %the emission matrix. Find the bounds for each of those and then take the most
  %stringent between them.
  [t, em] = hmmVector2Mat(vec, dims);
  [t_axis, em_axis] = hmmVector2Mat(axis, dims);
  num_marks = dims('neighbor_states');
  [mn, mx] = markovBounds(em, em_axis);
  for j=1:num_marks
      mat = t(:,:,j); 
      mat_axis = t_axis(:,:,j);
      [mn2, mx2] = markovBounds(mat, mat_axis);
      mn = max(mn, mn2);
      mx = min(mx, mx2);
  end
end

%given a markov matrix expressed with the last column missing, and a vector
%along which the rows of the matrix will vary, outputs the minimum and maximum
%scalar bounds for which the vector can be added to every row and still have the
%matrix satisfy the markov property

function [mn, mx] = markovBounds(mat, axis)
  row_mins = [];
  row_maxs = [];
  for j = 1:size(mat)
    row = mat(j, 1:size(mat,2)-1);
    ax = axis(j, 1:size(axis,2)-1);
    [rmin, rmax] = rowBounds(row, ax);
    row_maxs(j) = rmax;
    row_mins(j) = rmin;
  end
  %If any row doesn't satisfy the markov property, the matrix doesn't either.
  %So choose the strictest bounds.
  mn = max(row_mins);
  mx = min(row_maxs);
end

function [mn, mx] = rowBounds(row, axis)
  row = [row, sum(row)];
  axis = [axis, sum(axis)];
  one_intercepts = (1-row)./axis;
  zero_intercepts = (0-row)./axis;
  sz = size(one_intercepts, 2);
  sorted = sort([one_intercepts, zero_intercepts]);

  %choose the two bounds closest to zero on either side
  mn = sorted(1, sz);
  mx = sorted(1, sz+1);
end
