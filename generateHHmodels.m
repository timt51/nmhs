function [n1s, n2s, n3s, Ts] = generateHHmodels(tmax, samppersec, numCases)
    n1s = cell(11*numCases,1);
    n2s = cell(11*numCases,1);
    n3s = cell(11*numCases,1);
    Ts = cell(11*numCases,1);
    
    count = 0;
    for i = 1:11
        n2gsyn = 0.1*(i-1);
        for k = 1:numCases
            [n1, n2, n3, T] = hh_main(tmax, samppersec, 0.4, n2gsyn);
            count = count + 1;
            disp(count);
            n1s{count} = n1;
            n2s{count} = n2;
            n3s{count} = n3;
            Ts{count} = T;
        end
    end
end