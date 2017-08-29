#!/bin/bash

#SBATCH --job-name=topicmodel_c2
#SBATCH --nodes=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=350G
#SBATCH --time=168:00:00
#SBATCH --mail-type=END
#SBATCH --mail-user=qg251@nyu.edu

module purge
module load r/intel/3.3.2

cd /scratch/qg251/webscraping_guba/text_analysis

srun R CMD BATCH topic_modeling_for_separate_days_control2.R > topic_modeling_for_separate_days_control2.out 2>&1
