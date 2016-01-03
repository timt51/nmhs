function flag = isequalpoint(X,CachePoint,cachetol)
%ISEQUALPOINT Checks if two points are same within a tolerance
% 	Element wise comparison. Using AbsTol for speed only. For RelTol, choose a
% 	basis; %basis = min(abs(X(:)),abs(Xc(:))); %basis(abs(basis)<eps) = cachetol.

%   Copyright 2003-2007 The MathWorks, Inc.

flag = true;
for i = 1:length(X)
    if (abs( X(i) - CachePoint(i) ))  > cachetol
        flag = false;
        return;
    end
end

