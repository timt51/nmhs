function [total, percent] = statesError(true, trained)

if length(true) ~= length(trained)
    error('Inputs must be same length')
end
%if sort(unique(true)) ~= sort(unique(trained))
%    error('Inputs mismatch')
%end

len = length(true);
numStates = length(unique(true));

err = sum(true~=trained);
for i = 1:numStates
    trained = trained + 1;
    for j = 1:len
        if trained(j) == numStates + 1
            trained(j) = 1;
        elseif trained(j) > numStates
            error('Fatal')
        end
    end
    temp = sum(true~=trained);
    if temp < err
        err = temp;
    end
end

total = err;
percent = err/len;
