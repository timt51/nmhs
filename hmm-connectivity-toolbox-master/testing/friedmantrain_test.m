function friedmantrain_test()

%% Uncorrelated neurons 

tr1_true = [.95 .05;
               .1  .9];
tr1_true(:,:,2) = [.95 .05; .1 .9];
tr1_true(:,:,3) = [.95 .05; .1 .9];
e1_true = eye(2);

tr2_true = [.95 .03 .02; 
              .05 .9 .05; 
              .01 0 .99];
tr2_true(:,:,2) = [.95 .03 .02; .05 .9 .05; .01 0 .99];
e2_true = eye(3);

L = 1000;

[seq1, seq2, states1, states2] = hmmgenerate_multineuron(L,tr1_true, tr2_true, e1_true, e2_true);

tr1_guess = [.6 .4; .4 .6];
tr2_guess = [2/3 1/6 1/6; 
    1/6 2/3 1/6;
    1/6 1/6 2/3];
e1_guess = [.5 .5; .5 .5];
e2_guess = [1/3 1/3 1/3; 1/3 1/3 1/3; 1/3 1/3 1/3];

[tr1_trained, tr2_trained, e1_trained, e2_trained] = friedmantrain(seq1, seq2, tr1_guess, tr2_guess, ...
    e1_guess, e2_guess)

