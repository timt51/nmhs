function hmmgenerate_multineuron_tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Tests for hmmgenerate_multineuron %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Should pass: 1, 2.1-2.3, 3.1-3.3, 4.1-4.2, 5, 6, 7
%% Test 1: 2 identical independent neurons deterministically alternating
% between state 1 and state 2. Each state always emits its own number.
L = 10;
tr1  = [0 1; 1 0];
tr1(:,:,2) = [0 1; 1 0];
tr2 = tr1;
e1 = eye(2);
e2 = e1;
[seq1, seq2, states1, states2] = hmmgenerate_multineuron(L,tr1,tr2,e1,e2);
expected = [2 1 2 1 2 1 2 1 2 1];
if (expected == seq1)
    if (expected == seq2)
        if (expected == states1)
            if (expected == states2)
                disp('pass: Test1')
            end
        end
    end
end

%% Tests 2.1-2.3: two neurons, two states, N1 perfectly dependent on N2,
% N2 independent of N1, deterministic output
% Test 2.1: N2 always in state 1, N1 at time t is in the opposite state of
% N2 at t-1
L = 10;
tr1  = [0 0; 1 1];
tr1(:,:,2) = [1 1; 0 0];
tr2 = eye(2);
tr2(:,:,2) = eye(2);
e1 = eye(2);
e2 = e1;
[seq1, seq2, states1, states2] = hmmgenerate_multineuron(L,tr1,tr2,e1,e2)
states1_e = [2 2 2 2 2 2 2 2 2 2];
states2_e = [1 1 1 1 1 1 1 1 1 1];
seq1_e = states1_e;
seq2_e = states2_e;
if (seq1_e == seq1)
    if (seq2_e == seq2)
        if (states1_e == states1)
            if (states2_e == states2)
                disp('pass: Test2.1')
            end
        end
    end
end

% Test 2.2: N2 alternating states, N1 at time t is in the opposite state of
% N2 at t-1
tr2 = [0 1; 1 0];
tr2(:,:,2) = [0 1; 1 0];
[seq1, seq2, states1, states2] = hmmgenerate_multineuron(L,tr1,tr2,e1,e2);
states1_e = [2 1 2 1 2 1 2 1 2 1];
states2_e = [2 1 2 1 2 1 2 1 2 1];
seq1_e = states1_e;
seq2_e = states2_e;
if (seq1_e == seq1)
    if (seq2_e == seq2)
        if (states1_e == states1)
            if (states2_e == states2)
                disp('pass: Test2.2')
            end
        end
    end
end

% Test 2.3: N2 alternating states, N1 at time t is in the same state as
% N2 at t-1
tr1 = [1 1; 0 0];
tr1(:,:,2) = [0 0; 1 1];
[seq1, seq2, states1, states2] = hmmgenerate_multineuron(L,tr1,tr2,e1,e2);
states1_e = [1 2 1 2 1 2 1 2 1 2];
states2_e = [2 1 2 1 2 1 2 1 2 1];
seq1_e = states1_e;
seq2_e = states2_e;
if (seq1_e == seq1)
    if (seq2_e == seq2)
        if (states1_e == states1)
            if (states2_e == states2)
                disp('pass: Test2.3')
            end
        end
    end
end


%% Tests 3.1-3.3: Same as Test 2, but reverse the roles of N1 and N2
% Test 3.1:
L = 10;
tr2  = [0 0; 1 1];
tr2(:,:,2) = [1 1; 0 0];
tr1 = eye(2);
tr1(:,:,2) = eye(2);
e1 = eye(2);
[seq1, seq2, states1, states2] = hmmgenerate_multineuron(L,tr1,tr2,e1,e2);
states2_e = [2 2 2 2 2 2 2 2 2 2];
states1_e = [1 1 1 1 1 1 1 1 1 1];
seq1_e = states1_e;
seq2_e = states2_e;
if (seq1_e == seq1)
    if (seq2_e == seq2)
        if (states1_e == states1)
            if (states2_e == states2)
                disp('pass: Test3.1')
            end
        end
    end
end

% Test 3.2:
tr1 = [0 1; 1 0];
tr1(:,:,2) = [0 1; 1 0];
[seq1, seq2, states1, states2] = hmmgenerate_multineuron(L,tr1,tr2,e1,e2);
states2_e = [2 1 2 1 2 1 2 1 2 1];
states1_e = [2 1 2 1 2 1 2 1 2 1];
seq1_e = states1_e;
seq2_e = states2_e;
if (seq1_e == seq1)
    if (seq2_e == seq2)
        if (states1_e == states1)
            if (states2_e == states2)
                disp('pass: Test3.2')
            end
        end
    end
end

% Test 3.3:
tr2 = [1 1; 0 0];
tr2(:,:,2) = [0 0; 1 1];
[seq1, seq2, states1, states2] = hmmgenerate_multineuron(L,tr1,tr2,e1,e2);
states2_e = [1 2 1 2 1 2 1 2 1 2];
states1_e = [2 1 2 1 2 1 2 1 2 1];
seq1_e = states1_e;
seq2_e = states2_e;
if (seq1_e == seq1)
    if (seq2_e == seq2)
        if (states1_e == states1)
            if (states2_e == states2)
                disp('pass: Test3.3')
            end
        end
    end
end


%% Tests 4.1-4.2: two perfectly co-dependent neurons, deterministic
% Test 4.1: N1 = 1 or 2 => N2 = 2 or 1 (respectively) and vice versa
L = 10;
tr1  = [0 0; 1 1];
tr1(:,:,2) = [1 1; 0 0];
tr2 = tr1;
e1 = eye(2);
[seq1, seq2, states1, states2] = hmmgenerate_multineuron(L,tr1,tr2,e1,e2);
states2_e = [2 1 2 1 2 1 2 1 2 1];
states1_e = [2 1 2 1 2 1 2 1 2 1];
seq1_e = states1_e;
seq2_e = states2_e;
if (seq1_e == seq1)
    if (seq2_e == seq2)
        if (states1_e == states1)
            if (states2_e == states2)
                disp('pass: Test4.1')
            end
        end
    end
end

% Test 4.1: N1 = 1 or 2 => N2 = 1 or 2 (respectively) and vice versa
L = 10;
tr1  = [1 1; 0 0];
tr1(:,:,2) = [0 0; 1 1];
tr2 = tr1;
e1 = eye(2);
[seq1, seq2, states1, states2] = hmmgenerate_multineuron(L,tr1,tr2,e1,e2);
states2_e = [1 1 1 1 1 1 1 1 1 1];
states1_e = [1 1 1 1 1 1 1 1 1 1];
seq1_e = states1_e;
seq2_e = states2_e;
if (seq1_e == seq1)
    if (seq2_e == seq2)
        if (states1_e == states1)
            if (states2_e == states2)
                disp('pass: Test4.2')
            end
        end
    end
end

%% Test 5: Two independent neurons, probabilistic

L = 100000;
tr1  = [.9 .7; .1 .3];
tr1(:,:,2) = [.9 .7; .1 .3];
tr2 = tr1;
e1 = eye(2);
[seq1, seq2, states1, states2] = hmmgenerate_multineuron(L,tr1,tr2,e1,e2);
[sampledTr1, sampledTr2] = approximateTr(states1, states2, tr1);

% should be close to zero 
diff1 = tr1-sampledTr1;
diff2 = tr2-sampledTr2;
if diff1 < .05
    if diff2 < .05
        disp('pass: Test5 (probabilistic)')
    else
        disp('Error in Test5 (probabilistic). diff2 = ')
        disp(diff2)
    end
else
    disp('Error in Test5 (probabilistic). diff1 = ')
    disp(diff1)
end

%% Test 6: Two non-independent neurons, probabilistic
L = 100000;
tr1  = [.9 .7; .1 .3];
tr1(:,:,2) = [.8 .6; .2 .4];
tr1  = [.5 .7; .5 .3];
tr1(:,:,2) = [.2 .1; .8 .9];
e1 = eye(2);
[seq1, seq2, states1, states2] = hmmgenerate_multineuron(L,tr1,tr2,e1,e2);
[sampledTr1, sampledTr2] = approximateTr(states1, states2, tr1);

% should be close to zero 
diff1 = tr1-sampledTr1;
diff2 = tr2-sampledTr2;
if diff1 < .05
    if diff2 < .05
        disp('pass: Test6 (probabilistic)')
    else
        disp('Error in Test6 (probabilistic). diff2 = ')
        disp(diff2)
    end
else
    disp('Error in Test6 (probabilistic). diff1 = ')
    disp(diff1)
end


%% Test 7: different size trs
L = 10;
tr1  = [0 1; 1 0];
tr1(:,:,2) = [0 1; 1 0];
tr1(:,:,3) = [0 1; 1 0];
tr2 = [0 1 0; 0 0 1; 1 0 0];
tr2(:,:,2) = [0 1 0; 0 0 1; 1 0 0];
e1 = eye(2);
e2 = eye(3);
[seq1, seq2, states1, states2] = hmmgenerate_multineuron(L,tr1,tr2,e1,e2)
states1_e = [2 1 2 1 2 1 2 1 2 1];
states2_e = [3 1 2 3 1 2 3 1 2 3];
if (states1_e == seq1)
    if (states2_e == seq2)
        if (states1_e == states1)
            if (states2_e == states2)
                disp('pass: Test7')
            end
        end
    end
end



end

function [sampledTr1, sampledTr2] = approximateTr(states1, states2, tr)
% sampledTr is a reconstrution of tr using a noisy version of the states
% sequence. The 'tr' input is simply to get the size of the transition
% matrix.

T = size(states1, 2); %length of the states sequence
if T ~= size(states2, 2)
    error('State sequences must be same length')
end

counts1 = zeros(size(tr));
counts2 = zeros(size(tr));

for s = 1:T-1
    %increment counts1
    i = states1(s+1); %to
    j = states1(s); %from (this neuron)
    k = states2(s); %from (other neuron)
    counts1(i,j,k) = counts1(i,j,k) + 1;
    
    %increment counts2
    i = states2(s+1); %to
    j = states2(s); %from (this neuron)
    k = states1(s); %from (other neuron)
    counts2(i,j,k) = counts2(i,j,k) + 1;
end

%normalize
numStates = size(tr, 1);
sum1 = sum(counts1, 1);
sum2 = sum(counts2, 1);
sampledTr1 = zeros(size(tr));
sampledTr2 = zeros(size(tr));
for i=1:numStates
    for j=1:numStates
        for k=1:numStates
            sampledTr1(i,j,k) = counts1(i,j,k)/sum1(1,j,k);
            sampledTr2(i,j,k) = counts2(i,j,k)/sum2(1,j,k);
        end
    end
end

end









