% Hodgkin-Huxley circuit model implemented by Leif Gibb 6/28/15 through 12/26/15

function [n1, n2, n3, T,a,b,c,d] = hh_main_new(tmax, samppersec, n1gsyn, n2gsyn, n1n2prob)

    close all
    tic
    rng('shuffle')

    tmin = 0; % ms
    %tmax = 1000; % ms
    Nneur = 3;
    Nsyn = 2;
    %samppersec = 1000;
    spikedur = 5; % ms
    %n1gsyn = 0.2; % mS/cm^2
%     PLgsyn = 0.4;
    PLphasicdurmin = tmax-tmin;
    PLphasicdurmax = tmax-tmin;
    PLphasicspikefreqmin = 50; % 8;
    PLphasicspikefreqmax = 50; % 12;
    PLtonicdurmin = 0; % 3;
    PLtonicdurmax = 0; % 10;
    PLtonicspikefreqmin = 0; % 2;
    PLtonicspikefreqmax = 0; % 2;

    % VTA
%     VTAgsyn = 0.0;
    VTAphasicdurmin = tmax-tmin;
    VTAphasicdurmax = tmax-tmin;
    VTAphasicspikefreqmin = 50; % 12;
    VTAphasicspikefreqmax = 50; % 20;
    VTAtonicdurmin = 0; % 3;
    VTAtonicdurmax = 0; % 10;
    VTAtonicspikefreqmin = 0; % 4;
    VTAtonicspikefreqmax = 0; % 4;
    
%     PLphasicdurmin = 2;
%     PLphasicdurmax = 2;
%     PLphasicspikefreqmin = 50; % 8;
%     PLphasicspikefreqmax = 50; % 12;
%     PLtonicdurmin = 3; % 3;
%     PLtonicdurmax = 10; % 10;
%     PLtonicspikefreqmin = 7; % 2;
%     PLtonicspikefreqmax = 7; % 2;
% 
%     % VTA
% %     VTAgsyn = 0.0;
%     VTAphasicdurmin = 2;
%     VTAphasicdurmax = 2;
%     VTAphasicspikefreqmin = 50; % 12;
%     VTAphasicspikefreqmax = 50; % 20;
%     VTAtonicdurmin = 3; % 3;
%     VTAtonicdurmax = 10; % 10;
%     VTAtonicspikefreqmin = 7; % 4;
%     VTAtonicspikefreqmax = 7; % 4;
    
    timeline = tmin:tmax;
    [n1phasic n1spike] = hh_signal_new(timeline, samppersec, spikedur, PLphasicdurmin, PLphasicdurmax, PLphasicspikefreqmin, PLphasicspikefreqmax, PLtonicdurmin, PLtonicdurmax, PLtonicspikefreqmin, PLtonicspikefreqmax);
    [n2phasic n2spike] = hh_signal_new(timeline, samppersec, spikedur, VTAphasicdurmin, VTAphasicdurmax, VTAphasicspikefreqmin, VTAphasicspikefreqmax, VTAtonicdurmin, VTAtonicdurmax, VTAtonicspikefreqmin, VTAtonicspikefreqmax);

%     [spikecountout, freqout] = hh_freq(n1spike, tmax-tmin, 0.5);
%     freqout
%     [spikecountout, freqout] = hh_freq(n2spike, tmax-tmin, 0.5);
%     freqout

    Iin = 5.*[n1spike; n2spike; zeros(size(timeline))];

    [T,Y] = ode45(@hh_ode_new,[tmin tmax],[0.0003    0.0529    0.3177    0.5961    0.0003    0.0529    0.3177    0.5961    0.0003    0.0529    0.3177    0.5961 0 0 1 1],[],Nneur,Nsyn,timeline,Iin,n1gsyn);

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
    a = Y(:,13);
    b = Y(:,14);
    c = Y(:,15);
    d = Y(:,16);
end