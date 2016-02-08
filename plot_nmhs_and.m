load('./and_max_connectivities.mat');
x1 = max_connectivities;
load('./and_shuffled_max_connectivities.mat');
x2 = max_connectivities;

x = [mean(x1) mean(x2)];
disp(x1);
err = [std(x1)/sqrt(5) std(x2)/sqrt(5)];
str = {'AND'; 'AND Shuffled'};
barwitherr(err,x);
set(gca, 'XTickLabel',str, 'XTick',1:numel(str));

title('NMHS AND (5 Trials)');
ylabel('Connectivity');