function [reordered] = fixRows(true, trained)

if any(size(true) ~= size(trained))
    error('Could not reorder rows - different size matrices')
    reordered = trained;
    return
end

true_max_indices = zeros(1, size(true, 1));
trained_max_indices = zeros(1, size(trained, 1));
for i = 1:size(true, 1)
    [~, idx] = max(true(i,:));
    true_max_indices(i) = idx;
    
    [~, idx] = max(trained(i,:));
    trained_max_indices(i) = idx;
end


% if the maximums aren't in the same columns when sorted, can't rearrange
% if more than one maximum in same column, can't rearrange
if any(sort(true_max_indices) ~= sort(trained_max_indices)) ...
   || any(size(true_max_indices) ~= size(unique(true_max_indices)))
    error('Could not reorder rows')
    reordered = trained;
    return
end

reordered = zeros(size(trained));
for i = 1:size(true_max_indices, 2)
    idx = trained_max_indices == true_max_indices(i);
    reordered(i,:) = trained(idx,:);
end



