%% Generate fake neurons with PLgysn varies from 0 to 1, and VTAgysn varies from 1 to 2
tmax = 1000;
samppersec = 1000;
%PLgsyn = 0.4;
%VTAgsyn = 0.0;
binsize = 100; %% millisec

for i=0:4
    for j=0:4
        PLgsyn = i/4;
        VTAgsyn = j/2;
        str = strcat('fakeneuron3D_',num2str(i),'_',num2str(j));
        raw_str = strcat('fakeneuron3D_raw_',num2str(i),'_',num2str(j));

        [first second third T] = hh_main(tmax, samppersec, PLgsyn, VTAgsyn);
        raw_data = [first; second; third];
        save(raw_str,'raw_data');
        ff = countSpikes(first, T, tmax, binsize);
        ss = countSpikes(second, T, tmax, binsize);
        tt = countSpikes(third, T, tmax, binsize);
        data = [ff; ss; tt];
        save(str,'data');
        pump=strcat('finished',num2str(i),'_',num2str(j))
    end
end