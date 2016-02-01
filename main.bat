#!/bin/bash
#SBATCH --job-name=matlab
#SBATCH --output=MatlabJob-%j.out
#SBATCH --error=MatlabJob-%j.err
#SBATCH --mem=10000
#SBATCH --nodes=1
matlab -nosplash -singleCompThread -r main