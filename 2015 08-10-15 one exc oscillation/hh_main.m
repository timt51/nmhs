% Leif Gibb 6/28/15 through 8/10/15
function [n1, n2, n3, T] = hh_main(tmax, samppersec, n1gsyn, n2gsyn, n1n2prob)
    close all
    tic
    rng('shuffle')

    tmin = 0;
    Nneur = 2;
    Nsyn = 1;
    spikedur = 5;

    % Excitatory neuron "n1"
    n1Iin = 10;

    timeline = tmin:tmax;

    [T,Y] = ode45(@hh_ode,[tmin tmax],[-7.3885    0.1560    0.7145    0.0935   66.4072    0.9829    0.7012    0.1166    0.4613],[],Nneur,Nsyn,timeline,n1Iin,n1gsyn);

    toc

    %figure;
    %plot(T,Y(:,1),T,Y(:,5))
    n1 = Y(:,1);
    n2 = Y(:,1);
    n3 = Y(:,5);
end