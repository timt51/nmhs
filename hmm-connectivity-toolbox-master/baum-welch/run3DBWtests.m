function run3DBWTests(output_dir, seq_length)
  if output_dir(length(output_dir)) ~= '/'
    output_dir = [output_dir, '/'];
  end
  if ~exist(output_dir, 'dir')
    mkdir(output_dir);
  end

  joint_strings = {'dormant, excited jointly', 'dormant, inhibited jointly',...
                  'active, excited jointly', 'active, inhibited jointly'};
  unconnected_strings = {'dormant, unconnected', 'active, unconnected'};
  connected_stirngs = {'dormant, excited 1','active, inhibited 1',...
                       'active, inhibited 2', 'dormant, excited 2'};
                       
                       

  
  for i=1:length(joint_strings)
    for j = 1:length(unconnected_strings)
      for k = 1:length(unconnected_strings)
          testHMMs(joint_strings{i}, unconnected_strings{j}, ...
                   unconnected_strings{k}, seq_length, output_dir);
      end
    end
  end
  for i=1:length(unconnected_strings)
    for j = 1:length(connected_strings)
      for k = 1:length(connected_strings)
          testHMMs(joint_strings{i}, unconnected_strings{j}, ...
                   unconnected_strings{k}, seq_length, output_dir);
      end
    end
  end
end



function testHMMs(tr1_name, tr2_name, tr3_name, seq_length, output_dir)
  %display current model being worked on
  disp(['Now working on model ', tr1_name, ';', tr2_name, ';', tr3_name]);
  [ground_truth, guess, data, gt_logL, guess_logL] = generate3DModel({tr1_name, ...
                                                                      tr2_name, ...
                                                                      tr3_name}, seq_length);
  flattened_model = flatten3DModel(ground_truth);
  [tr1_flat, tr2_flat, tr3_flat, em1, em2, em3] = unpack3DHMM(flattened_model);
  [seq1_flat, seq2_flat, seq3_flat] = hmmgenerate3d(seq_length, tr1_flat,...
                                                    tr2_flat, tr3_flat, em1, em2, em3);
  data_flat = {seq1_flat, seq2_flat, seq3_flat};


  %train 3d and 2d and 1d hmm on flat and connected data-sets, and record initial
  %and trained logL's.  
  [connected_2d_logLs, connected_2d_models] = best2DestimateOf3D(ground_truth, data);
  [connected_3d_logL, connected_3d_model] = best3Destimate(ground_truth, data);
  [connected_1d_logL, connected_1d_model] = best1DestimateOf3D(ground_truth, data);

  
  [unconnected_3d_logL, unconnected_3d_model] = best3Destimate(flattened_model, data_flat);
  [unconnected_1d_logL, unconnected_1d_model] = best1DestimateOf3D(flattened_model, data_flat);
  [unconnected_2d_logLs, unconnected_2d_models] = best2DestimateOf3D(ground_truth, data);        


  connected_results = containers.Map({'connected_3d_model','connected_1d_model', 'connected_2d_models'}, {connected_3d_model,connected_1d_model, connected_2d_models});
  
  unconnected_results = containers.Map({'unconnected_3d_model','unconnected_1d_model', 'unconnected_2d_models'}, {unconnected_3d_model,unconnected_1d_model, unconnected_2d_models});

  logLs = containers.Map({'connected_3d_logL', 'connected_1d_logL', ...
                          'connected_2d_logLs', 'unconnected_3d_logL',...
                          'unconnected_1d_logL', 'unconnected_2d_logLs'},...
                         {connected_3d_logL, connected_1d_logL,...
                          connected_2d_logLs, unconnected_3d_logL,...
                          unconnected_1d_logL, unconnected_2d_logLs});
  
  %pack everything into a nice dict
  results = containers.Map({'connected_results', 'unconnected_results', 'logLs'},...
                           {connected_results, unconnected_results, logLs});  
  

  %save to disk
  save(strcat(output_dir, tr1_name, '_', tr2_name, '_', tr3_name, '_', num2str(seq_length)),...
       'results');
end
