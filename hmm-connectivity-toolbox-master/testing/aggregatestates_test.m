function aggregatestates_test()
numstates1 = 3;
numstates2 = 2;
states1 = [1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3];
states2 = [2 2 2 2 2 2 2 2 2 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2];
obs1 = states1;
obs2 = states2;

expectedset1 = {};
subset_s2 = {};
subset_s2{end+1} = [1 1 1 1 1 1 1 1 2];
subset_s2{end+1} = [2 2 3 3 3 3 3 3 3 3];
subset_s1 = {};
subset_s1{end+1} = [2 2 2 2 2];
expectedset1{end+1} = subset_s1;
expectedset1{end+1} = subset_s2;

expectedset2 = {};
subset_s1 = {};
subset_s1{end+1} = [2 2 2 2 2 2 2 2];
subset_s2 = {};
subset_s2{end+1} = [2 1 1 1 1 1 2 2];
subset_s3 = {};
subset_s3{end+1} = [2 2 2 2 2 2 2 2];
expectedset2{end+1} = subset_s1;
expectedset2{end+1} = subset_s2;
expectedset2{end+1} = subset_s3;

[trainingset1, trainingset2] = ...
    agrregatestates(states1, states2, obs1, obs2, numstates1, numstates2);

if isequal(expectedset1, trainingset1)
    if isequal(expectedset2, trainingset2)
        disp('OK')
    else
        disp('error in set2: expected vs calculated')
        disp(expectedset2)
        disp(trainingset2)
    end
else
    disp('error in set1: expected vs calculated')
    disp(expectedset1)
    disp(trainingset1)
end
    
    