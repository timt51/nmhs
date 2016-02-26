% Hodgkin-Huxley circuit model implemented by Leif Gibb 6/28/15 through 2/13/16
% Minor changes made by Timothy Truong ca December 2015 through February 2016
% Modified by Leif Gibb 2/12/16 to implement frequency-based XOR
% Modified by Leif Gibb 2/20/16 and 2/22/16
%
% Suggested input parameters:
% samppersec = 1000;
% n1gsyn = 0.4; % mS/cm^2

function [n1, n2, n3, T,a,b,c,d] = hh_main(tmax, samppersec, n1gsyn)

    close all
    tic
    rng('shuffle')

    tmin = 0; % ms
%     tmax = 5000; % ms
    Nneur = 3;
    Nsyn = 2;
%     samppersec = 1000;
    spikedur = 5; % ms
%     n1gsyn = 0.4; % mS/cm^2
    
    % n1
    n1phasicdurmin = 1;
    n1phasicdurmax = 1;
    n1phasicspikefreqmin = 50;
    n1phasicspikefreqmax = 50;
    n1tonicdurmin = 1;
    n1tonicdurmax = 1;
    n1tonicspikefreqmin = 0;
    n1tonicspikefreqmax = 0;

    % n2
    n2phasicdurmin = 1;
    n2phasicdurmax = 1;
    n2phasicspikefreqmin = 50;
    n2phasicspikefreqmax = 50;
    n2tonicdurmin = 1;
    n2tonicdurmax = 1;
    n2tonicspikefreqmin = 0;
    n2tonicspikefreqmax = 0;
    
    timeline = tmin:tmax;
    [n1phasic n1spike] = hh_signal(timeline, samppersec, spikedur, n1phasicdurmin, n1phasicdurmax, n1phasicspikefreqmin, n1phasicspikefreqmax, n1tonicdurmin, n1tonicdurmax, n1tonicspikefreqmin, n1tonicspikefreqmax);
    [n2phasic n2spike] = hh_signal(timeline, samppersec, spikedur, n2phasicdurmin, n2phasicdurmax, n2phasicspikefreqmin, n2phasicspikefreqmax, n2tonicdurmin, n2tonicdurmax, n2tonicspikefreqmin, n2tonicspikefreqmax);
    
%     [spikecountout, freqout] = hh_freq(n1spike, tmax-tmin, 0.5);
%     freqout
%     [spikecountout, freqout] = hh_freq(n2spike, tmax-tmin, 0.5);
%     freqout

    Iin = 5.*[n1spike; n2spike; zeros(size(timeline))];

    [T,Y] = ode45(@hh_ode,[tmin tmax],[0.0003    0.0529    0.3177    0.5961    0.0003    0.0529    0.3177    0.5961    0.0010    0.0529    0.3177    0.5961    0.0000    0.0000    0.9992    0.9992],[],Nneur,Nsyn,timeline,Iin,n1gsyn);

    toc

%     [spikecountout, freqout] = hh_freq(Y(:,1), tmax-tmin, 70);
%     freqout
%     [spikecountout, freqout] = hh_freq(Y(:,5), tmax-tmin, 70);
%     freqout
%     [spikecountout, freqout] = hh_freq(Y(:,9), tmax-tmin, 70);
%     freqout

    n3spikes = hh_spikes(Y(:,9), 70);   
    n3instfreq = hh_instfreq(n3spikes, T);
        
    n1phasic = interp1(timeline, single(n1phasic), T);
    n2phasic = interp1(timeline, single(n2phasic), T);
    n1n2xor = xor(n1phasic, n2phasic);
    
    xorgoodness = hh_xorgoodness(n1n2xor, n3instfreq)
        
%     figure, subplot(2,1,1), plot(T, n1n2xor), ylim([-0.1 1.1]), subplot(2,1,2), plot(T, n3instfreq)
    
    n1 = Y(:, 1);
    n2 = Y(:, 5);
    n3 = Y(:, 9);
    a = Y(:,13);
    b = Y(:,14);
    c = Y(:,15);
    d = Y(:,16);

end