function [C_A, A_C, logLs] = nmhs2D(n1, n2, n3, T, tmax, binSize)
    %number of spikes/neuron
    n1Spikes = countSpikes(n1, T, tmax, binSize); n1Spikes(n1Spikes > 3) = 3;
    n2Spikes = countSpikes(n2, T, tmax, binSize); n2Spikes(n2Spikes > 3) = 3;
    n3Spikes = countSpikes(n3, T, tmax, binSize); n3Spikes(n3Spikes > 3) = 3;

    %figure(1); plot(T, n1);
    %figure(2); plot(T, n2);
    %figure(3); plot(T, n3);

%     tmatArchetypes = {'null hypothesis', 'dormant, unconnected', ...
%         'dormant, excited 1', 'dormant excited 2', 'dormant, excited jointly', ...
%         'dormant, inhibited 1', 'dormant inhibited 2', ...
%         'dormant, inhibited jointly', 'active, unconnected', ...
%         'active, excited 1', 'active, excited 2', 'active, excited jointly', ...
%         'active, inhibited 1', 'active, inhibited 2', 'active, inhibited jointly'};
    tmatArchetypes = {'dormant, unconnected', 'dormant, excited', ...
        'dormant, inhibited', 'active, excited', ...
        'active, inhibited', 'active, unconnected', ...
        'null hypothesis'};

    C_A = 0;
    A_C = 0;
    tmatBest = 0;
    logLs = -9999999;
    
    em1_guess=[0.7 0.1 0.1 0.1;0.1 0.7 0.1 0.1];
    em3_guess=[0.7 0.1 0.1 0.1;0.1 0.7 0.1 0.1];

    for i = 1:length(tmatArchetypes)
        tr1_guess = archetypeLookup(tmatArchetypes{i}, 2);
        tr3_guess = archetypeLookup(tmatArchetypes{i}, 2);

        [tr1, tr3, em1, em2, logLsNew] = baum_welch2d(tr1_guess, tr3_guess, em1_guess, em3_guess, n1Spikes+1, n3Spikes+1);
        
        if (max(logLsNew) > logLs)
            logLs = max(logLsNew);
            [C_A,~,~,~] = connectivity(tr3, tr1, 0);
            [A_C,~,~,~] = connectivity(tr1, tr3, 0);
            tmatBest = i;
            disp(tmatArchetypes{i});
            disp([logLs, max(C_A)]);
        end
    end
    
    tr1_guess = archetypeLookup(tmatArchetypes{tmatBest}, 2);
    tr3_guess = archetypeLookup(tmatArchetypes{tmatBest}, 2);
    
    [~, ~, logLs1D_n1] = baum_welch1d(n1Spikes+1, tr1_guess(:,:,1), em1_guess);
    [~, ~, logLs1D_n3] = baum_welch1d(n3Spikes+1, tr3_guess(:,:,2), em3_guess);
    
    disp(logLs1D_n1(end)+logLs1D_n3(end));
    disp(logLs);
    
    if (max(logLs1D_n1)+max(logLs1D_n3) > 1.005*logLs)
        C_A = 0;
        A_C = 0;
    end
end