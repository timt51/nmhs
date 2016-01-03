#!/bin/bash
#use module add mit/matlab/2014a; sbatch -N3 -n49 --ntasks-per-node=17 --mem-per-cpu=8000 to run
srun -N3 -n49 --ntasks-per-node=17 --mem-per-cpu=8000 runOpenMindWrapper.sh
