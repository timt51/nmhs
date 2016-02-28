files = dir('./');

n1s_new = {};
n2s_new = {};
n3s_new = {};
Ts_new = {};
count = 1;

for f = files'
    a = strsplit(f.name,'.');
    a = a{1};
    if strcmp(a(1:end-2), 'EXC_EXC_n2gsyn_')
        load(f.name);
        disp(f.name);
        for i = 1:10
            n1s_new{count} = n1s{i};
            n2s_new{count} = n2s{i};
            n3s_new{count} = n3s{i};
            Ts_new{count} = Ts{i};
            count = count + 1;
        end
    end
end

n1s = n1s_new;
n2s = n2s_new;
n3s = n3s_new;
Ts = Ts_new;
save('EXC_EXC_n2gsyn','n1s','n2s','n3s','Ts');