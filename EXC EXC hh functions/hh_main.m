function [first second third T] = hh_main(tmax, samppersec, PLgsyn, VTAgsyn, n1n2prob)
    % Hodgkin-Huxley circuit model implemented by Leif Gibb 6/28/15 through 7/5/15

    close all
    tic
    rng('shuffle')

    tmin = 0;
%     tmax = 20000;
    Nneur = 3;
    Nsyn = 2;
%     samppersec = 1000;
    spikedur = 5;

    % PL
%     PLgsyn = 0.4;
    PLphasicdurmin = 2;
    PLphasicdurmax = 2;
    PLphasicspikefreqmin = 50; % 8;
    PLphasicspikefreqmax = 50; % 12;
    PLtonicdurmin = 3; % 3;
    PLtonicdurmax = 10; % 10;
    PLtonicspikefreqmin = 7; % 2;
    PLtonicspikefreqmax = 7; % 2;

    % VTA
%     VTAgsyn = 0.0;
    VTAphasicdurmin = 2;
    VTAphasicdurmax = 2;
    VTAphasicspikefreqmin = 50; % 12;
    VTAphasicspikefreqmax = 50; % 20;
    VTAtonicdurmin = 3; % 3;
    VTAtonicdurmax = 10; % 10;
    VTAtonicspikefreqmin = 7; % 4;
    VTAtonicspikefreqmax = 7; % 4;

    timeline = tmin:tmax;
    [PLphasic PLspike] = hh_signal(timeline, samppersec, spikedur, PLphasicdurmin, PLphasicdurmax, PLphasicspikefreqmin, PLphasicspikefreqmax, PLtonicdurmin, PLtonicdurmax, PLtonicspikefreqmin, PLtonicspikefreqmax);
    [VTAphasic VTAspike] = hh_signal(timeline, samppersec, spikedur, VTAphasicdurmin, VTAphasicdurmax, VTAphasicspikefreqmin, VTAphasicspikefreqmax, VTAtonicdurmin, VTAtonicdurmax, VTAtonicspikefreqmin, VTAtonicspikefreqmax);

    Iin = 5.*[PLspike; VTAspike; zeros(size(timeline))];

    [T,Y] = ode45(@hh_ode,[tmin tmax],[0.0003    0.0529    0.3177    0.5961    0.0003    0.0529    0.3177    0.5961    0.0003    0.0529    0.3177    0.5961 0 0],[],Nneur,Nsyn,timeline,Iin,[PLgsyn VTAgsyn]);

    toc

    % figure;
    % plot(tmin:tmax,PLphasic);
    % axis([tmin tmax -0.5 1.5]);
%     figure;
%     plot(tmin:tmax,PLspike);
%     axis([tmin tmax -0.5 1.5]);

    % figure;
    % plot(tmin:tmax,VTAphasic);
    % axis([tmin tmax -0.5 1.5]);
    % figure;
    % plot(tmin:tmax,VTAspike);
    % axis([tmin tmax -0.5 1.5]);

%     figure(1);
%     plot(T,Y(:,1))
%     figure(2);
%     plot(T,Y(:,5))
%     figure(3);
%     plot(T,Y(:,9))
%     figure(4);
%     plot(T,Y(:,13))
%     figure(5);
%     plot(T,Y(:,14))

    first = Y(:,1);
    first = first.';
    second = Y(:,5);
    second = second.';
    third = Y(:,9);
    third = third.';
    T = T.';
end