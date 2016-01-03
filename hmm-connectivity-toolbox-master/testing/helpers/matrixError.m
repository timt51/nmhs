function err = matrixError(tr_true, e_true, tr_estimate, e_estimate)
% Both TRs must be NxN and both Es must be NxM


if size(tr_true) ~= size(tr_estimate) 
    error('Both TR matrices must be same size')
end
if size(e_true) ~= size(e_estimate)
    error('Both E matrices must be same size')
end

err = sum(sum(abs(tr_true-tr_estimate))) + sum(sum(abs(e_true-e_estimate)));
