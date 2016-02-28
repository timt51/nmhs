% Hodgkin-Huxley circuit model implemented by Leif Gibb 6/28/15 through 7/5/15 and 2/25/16 through 2/26/16

function [n1,n2,n3,T] = hh_main(tmax,samppersec, Nneursecondary_max)

    close all
    tic
    rng('shuffle')

    tmin = 0;
%     tmax = 10000;
    Nneurpostsyn = 1;
    Nneurprimary = 1;
%     Nneursecondary_max = 6;
%     samppersec = 10000;
    spikedur = 5;

    % 1 primary neuron
    gsynprimary = 0.4;

    % Up to 6 secondary neurons
    gsynsecondary = 0.2;

    phasicdurmin = 2;
    phasicdurmax = 2;
    phasicspikefreqmin = 50;
    phasicspikefreqmax = 50;
    tonicdurmin = 3;
    tonicdurmax = 10;
    tonicspikefreqmin = 7;
    tonicspikefreqmax = 7;

    for Nneursecondary = Nneursecondary_max:Nneursecondary_max

        Nneur = Nneurpostsyn + Nneurprimary + Nneursecondary;
        Nsyn = Nneurprimary + Nneursecondary;

        timeline = tmin:tmax;

        spikearray = zeros(Nneur,length(timeline));
        gsyn = zeros(1,Nsyn);
        for i = 2:Nneur
            [phasic spike] = hh_signal(timeline, samppersec, spikedur, phasicdurmin, phasicdurmax, phasicspikefreqmin, phasicspikefreqmax, tonicdurmin, tonicdurmax, tonicspikefreqmin, tonicspikefreqmax);
    %         figure, plot(timeline,phasic), axis([tmin tmax -0.1 1.1])
            spikearray(i,:) = spike;
            if i <= 1 + Nneurprimary
                gsyn(i-1) = gsynprimary;
            else
                gsyn(i-1) = gsynsecondary;
            end
        end
        Iin = 5.*spikearray;

        Y0 = [repmat([0.0003 0.0529 0.3177 0.5961],1,Nneur) zeros(1,Nsyn)];
        [T,Y] = ode45(@hh_ode,[tmin tmax],Y0,[],Nneur,Nsyn,timeline,Iin,gsyn);

        toc

%         for i = 1:Nneur
%             figure, plot(timeline,Iin(i,:)), axis([tmin tmax -0.1 5.1])
%             figure, plot(T,Y(:,4*(i-1)+1))
%         end
%         for j = 1:Nsyn
%             figure, plot(T,Y(:,4*Nneur + j))
%         end

    end
    n1 = Y(:,5);
    n2 = Y(:,5);
    n3 = Y(:,1);
end