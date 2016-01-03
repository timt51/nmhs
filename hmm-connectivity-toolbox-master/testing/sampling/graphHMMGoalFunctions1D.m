function graphHMMGoalFunctions1D(samples, scalars, n1_name, n2_name, ...
                                 false_archetype_name, num_trials, data, normalize);
  figure;
  hold all;
  %set title
  title({strcat('goal functions for a ', n1_name, ' neuron'); strcat('neighbor neuron is a ', n2_name, ' neuron - alternative hypothesis is a ', false_archetype_name, ' neuron.')});
  
  %label axis
  xlabel('linear interpolation factor')
  ylabel('normalized goal-function value')

 
  
  %plot goal functions
  for j=1:length(keys(samples))
    ks = keys(samples);
    points = samples(ks{j});
    if normalize
      points = (points - min(points))/(max(points)-min(points)); %range 0-1
    end
    plot(scalars, points);
  end

  %add legend
  legend(keys(samples));  
