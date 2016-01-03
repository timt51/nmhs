function openMindWrapper()
  global neuronTypes;
  neuronTypes = {'dormant, unconnected', 'dormant, excited', ...
                 'moderate, inhibited', 'moderate, unconnected', ...
                 'moderate, excited', 'active, inhibited', ...
                 'active, unconnected'};
  try
    addpath ../;
    addpath ../../;
    addpath ../helpers;
    num_trials = 1;
    noise_coeffs = [1]
    gf_name = 'logLChange'
    chain_length = 2500;
    filepath = '/om/user/jslocum/hmm2dlearning/hmmtrainresults-10-29-14'
    n1_guess_name = 'null hypothesis'; n2_guess_name = 'null hypothesis';
    [n1_name, n2_name] = getNeuronPairNames();
    for j=1:length(noise_coeffs)
      noise_coeff = noise_coeffs(j);
      runTrials(n1_name, n2_name, n1_guess_name, n2_guess_name, num_trials,...
                noise_coeff, gf_name, chain_length, filepath);
    end
  catch err
    disp(err)
    disp(err.message)
    disp(err.stack)
    disp(err.identifier)
  end
  quit();
end

function [n1_name, n2_name] = getNeuronPairNames()
  global neuronTypes;
  procid = str2num(getenv('SLURM_PROCID')) 
  n1_name = neuronTypes{ceil((procid+1)/length(neuronTypes))} %procid starts at 0
  n2_name = neuronTypes{mod((procid+1),length(neuronTypes))+1}
end

         
      
