function graphHMMGoalFunctions2D(samples, scalars1, scalars2, n1_name, n2_name, ...
                                  false_archetype_name1, false_archetype_name2, ...
                                  num_trials, data, normalize);
  figure;
  %hold all;
  %set title
  title({strcat('goal functions for a ', n1_name, ' neuron'); strcat('neighbor neuron is a ', n2_name, ' neuron - alternative hypothesis is ', false_archetype_name1, ' and ', false_archetype_name2,' neurons.')});
  
  %label axis
  %xlabel('linear interpolation factor')
  %ylabel('normalized goal-function value')


  
  %plot goal functions
  for j=1:length(keys(samples))
    ks = keys(samples);
    points = samples(ks{j});
    if normalize
      points = (points - min(min(points)))/(max(max(points))-min(min(points))); %range 0-1
    end
    surf(scalars1, scalars2, points);
    hold all
  end

  %add legend
  legend(keys(samples)); 
