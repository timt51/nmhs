function [n1s, n2s, n3s, Ts] = generateHHmodels(tmax, samppersec, numCases, n2gsyn)
    n1s = cell(11*numCases,1);
    n2s = cell(11*numCases,1);
    n3s = cell(11*numCases,1);
    Ts = cell(11*numCases,1);
    
    parfor (k = 1:numCases, 10)
        [n1, n2, n3, T] = hh_main(tmax, samppersec, 0.5, n2gsyn);
        n1s{k} = n1;
        n2s{k} = n2;
        n3s{k} = n3;
        Ts{k} = T;
    end
end