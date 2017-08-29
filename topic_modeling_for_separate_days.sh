#!/bin/bash

#SBATCH --job-name=topicmodel
#SBATCH --nodes=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=350G
#SBATCH --time=120:00:00
#SBATCH --mail-type=END
#SBATCH --mail-user=qg251@nyu.edu

module purge
module load r/intel/3.3.2

cd /scratch/qg251/webscraping_guba/text_analysis

srun R CMD BATCH topic_modeling_for_separate_days.R > topic_modeling_for_separate_days.out 2>&1
