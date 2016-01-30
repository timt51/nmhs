% Hodgkin-Huxley circuit model implemented by Leif Gibb 6/28/15 through 12/26/15

function [n1, n2, n3, T] = hh_main(tmax, samppersec, n1gsyn, n2gsyn, n1n2prob)

    close all
    tic
    rng('shuffle')

    tmin = 0; % ms
    %tmax = 1000; % ms
    Nneur = 3;
    Nsyn = 2;
    %samppersec = 1000;
    spikedur = 5; % ms
    signalrefrac = 100; % ms
    spikefreq = 3; % Hz
    %n1gsyn = 0.2; % mS/cm^2

    timeline = tmin:tmax;
    [n1spike, n2spike] = hh_signal(timeline, samppersec, spikedur, spikefreq, signalrefrac, n1n2prob);

%     [spikecountout, freqout] = hh_freq(n1spike, tmax-tmin, 0.5);
%     freqout
%     [spikecountout, freqout] = hh_freq(n2spike, tmax-tmin, 0.5);
%     freqout

    Iin = 5.*[n1spike; n2spike; zeros(size(timeline))];

    [T,Y] = ode45(@hh_ode,[tmin tmax],[0.0003    0.0529    0.3177    0.5961    0.0003    0.0529    0.3177    0.5961    0.0003    0.0529    0.3177    0.5961 0 0 1 1],[],Nneur,Nsyn,timeline,Iin,n1gsyn);

    toc

%     [spikecountout, freqout] = hh_freq(Y(:,1), tmax-tmin, 70);
%     freqout
%     [spikecountout, freqout] = hh_freq(Y(:,5), tmax-tmin, 70);
%     freqout
%     [spikecountout, freqout] = hh_freq(Y(:,9), tmax-tmin, 70);
%     freqout

%     figure
%     plot(T,Y(:,1),T,Y(:,5)+10,T,Y(:,9)+20)

    n1 = Y(:, 1);
    n2 = Y(:, 5);
    n3 = Y(:, 9);
end