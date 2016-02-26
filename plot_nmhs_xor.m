load('./xor_max_connectivities_3d.mat');
x1 = [];
for i = 1:length(max_connectivities)
    x1(i) = max(max_connectivities{i});
end
load('./xor_shuffled_max_connectivities_3d.mat');
x2 =[];
for i = 1:length(max_connectivities)
    x2(i) = max(max_connectivities{i});
end

x = [mean(x1) mean(x2)];
err = [std(x1)/length(x1) std(x2)/length(x2)];
str = {'XOR'; 'XOR Shuffled'};
barwitherr(err,x);
set(gca, 'XTickLabel',str, 'XTick',1:numel(str));

title('NMHS XOR (10 Trials)');
ylabel('Connectivity');