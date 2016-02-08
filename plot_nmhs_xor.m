load('./xor_max_connectivities.mat');
x1 = max_connectivities;
load('./xor_shuffled_max_connectivities.mat');
x2 = max_connectivities;

x = [mean(x1) mean(x2)];
err = [std(x1)/sqrt(5) std(x2)/sqrt(5)];
str = {'XOR'; 'XOR Shuffled'};
barwitherr(err,x);
set(gca, 'XTickLabel',str, 'XTick',1:numel(str));

title('NMHS XOR (5 Trials)');
ylabel('Connectivity');