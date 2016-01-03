#!/usr/local/bin/python
import sys
import os

if len(sys.argv) < 2:
    print "ERROR: generateTests.py requires an output filename"
    exit()

params = [4000, 80000, 0, 3]
params[0:len(sys.argv)-2] = sys.argv[2:]
params = map(int, params)

seq_length, time_limit, duplicates, states = params

#arglist: neuron1 name, neuron2 name, sequence length, time limit, number of states per neuron
#command_template ="""cd ~/hmm-connectivity-toolbox/; matlab -singleCompThread -nojvm -nodisplay -nosplash -r "initPath(); openMindAnnealTest('%s', '%s', %i, %i, %i);" < /dev/null"""

resume_command_template ="""cd ~/hmm-connectivity-toolbox/; matlab -singleCompThread -nojvm -nodisplay -nosplash -r "initPath(); openMindResumeAnnealTest('%s', '%s', %i, %i, %s, %i);" < /dev/null"""



three_state_names = ['dormant, unconnected','dormant, excited','moderate, inhibited','moderate, unconnected','moderate, excited','active, inhibited','active, unconnected']

two_state_names = ['dormant, unconnected','dormant, excited','dormant, inhibited','active, excited','active, inhibited','active, unconnected']


with open(sys.argv[1], 'w') as out_file:
    if states == 3 or states <0:
        for name1 in three_state_names:
            for name2 in three_state_names:        
                out_file.write(resume_command_template %
                               (name1, name2, seq_length, time_limit/8, 'true', 3) + '\n')
                out_file.write(resume_command_template %
                               (name1, name2, seq_length, time_limit/8, 'false', 3) + '\n')
                if name1==name2:
                    for j in range(duplicates):
                        out_file.write(command_template %
                                       (name1, name2, seq_length+duplicates+1, time_limit, 3) + '\n')
    if states == 2 or states <0:
        for name1 in two_state_names:
            for name2 in two_state_names:        
                out_file.write(resume_command_template %
                               (name1, name2, seq_length, time_limit/8, 'true',2) + '\n')
                out_file.write(resume_command_template %
                                   (name1, name2, seq_length, time_limit/8, 'false',2) + '\n')
                if name1==name2:
                    for j in range(duplicates):
                        out_file.write(command_template %
                                       (name1, name2, seq_length+duplicates+1, time_limit, 2) + '\n')
