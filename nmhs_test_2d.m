addpath(genpath('./hmm-connectivity-toolbox-master'),'-end');

max_connectivities = zeros(1,5);

parfor (j = 1:5,2)
    n1Spikes = round(rand(1,700));
    n2Spikes = round(rand(1,700));
    n3Spikes = circshift(xor(n1Spikes,n2Spikes),[0,1]);
    n1Spikes = n1Spikes(2:end-1);
    n2Spikes = n2Spikes(2:end-1);
    n3Spikes = n3Spikes(2:end-1);
    n3Spikes = n3Spikes(randperm(length(n3Spikes)));

    tmatArchetypes = {'dormant, unconnected', 'dormant, excited', ...
        'dormant, inhibited', 'active, excited', ...
        'active, inhibited', 'active, unconnected', ...
        'null hypothesis'};

    tr_matrices_1 = {};
    tr_matrices_2 = {};
    tmatBest_1 = 0;
    tmatBest_2 = 0;
    logLsOld_1 = -999999999;
    logLsOld_2 = -999999999;
    connectivities_1 = [];
    connectivities_2 = [];

    em1_guess=[0.7 0.1 0.1 0.1;.1 .7 .1 .1];
    em2_guess=[0.7 0.1 0.1 0.1;.1 .7 .1 .1];
    em3_guess=[0.7 0.1 0.1 0.1;.1 .7 .1 .1];
    
    for i = 1:length(tmatArchetypes)
        tr1_guess = archetypeLookup(tmatArchetypes{i}, 2);
        tr2_guess = archetypeLookup(tmatArchetypes{i}, 2);
        tr3_guess = archetypeLookup(tmatArchetypes{i}, 2);

        [tr1, tr3_1, ~, ~, logLsNew_1] = baum_welch2d_mod(tr1_guess, tr3_guess, em1_guess, em3_guess, n1Spikes+1, n3Spikes+1,true);
        [tr2, tr3_2, ~, ~, logLsNew_2] = baum_welch2d_mod(tr2_guess, tr3_guess, em2_guess, em3_guess, n2Spikes+1, n3Spikes+1,true);

        if max(logLsNew_1) > logLsOld_1
           tmatBest_1 = i;
           logLsOld_1 = max(logLsNew_1);
           [C_A,~,~,~] = connectivity(tr3_1, tr1, 0);
           [A_C,~,~,~] = connectivity(tr1, tr3_1, 0);
           [C_B,~,~,~] = connectivity(tr3_2, tr2, 0);
           [B_C,~,~,~] = connectivity(tr2, tr3_2, 0);
        end
        
        if max(logLsNew_2) > logLsOld_2
           tmatBest_2 = i;
           logLsOld_2 = max(logLsNew_2);
           [C_A,~,~,~] = connectivity(tr3_1, tr1, 0);
           [A_C,~,~,~] = connectivity(tr1, tr3_1, 0);
           [C_B,~,~,~] = connectivity(tr3_2, tr2, 0);
           [B_C,~,~,~] = connectivity(tr2, tr3_2, 0);
        end
    end
    
    tr1_guess = archetypeLookup(tmatArchetypes{tmatBest_1}, 2);
    tr2_guess = archetypeLookup(tmatArchetypes{tmatBest_2}, 2);
    tr3_1_guess = archetypeLookup(tmatArchetypes{tmatBest_1}, 2);
    tr3_2_guess = archetypeLookup(tmatArchetypes{tmatBest_2}, 2);
        
    [~, ~, logLs1D_n1] = baum_welch1d(n1Spikes+1, tr1_guess(:,:,1), em1_guess);
    [~, ~, logLs1D_n2] = baum_welch1d(n2Spikes+1, tr2_guess(:,:,1), em2_guess);
    [~, ~, logLs1D_n3_1] = baum_welch1d(n3Spikes+1, tr3_1_guess(:,:,2), em3_guess);
    [~, ~, logLs1D_n3_2] = baum_welch1d(n3Spikes+1, tr3_2_guess(:,:,2), em3_guess);
    
    disp([max(logLs1D_n1)+max(logLs1D_n3_1) logLsOld_1 max(logLs1D_n2)+max(logLs1D_n3_2) logLsOld_2])
    if (max(logLs1D_n1)+max(logLs1D_n3_1) > 1.0015*logLsOld_1)
        C_A = 0;
    	A_C = 0;
    end
    if (max(logLs1D_n2)+max(logLs1D_n3_2) > 1.0015*logLsOld_2)
        C_B = 0;
    	B_C = 0;
    end
    max_connectivities(j) = max(C_A,C_B);
end