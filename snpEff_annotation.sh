#!/bin/bash
##Author:Sen Peng


Location_DIR=/scratch/speng/projects/IVY_GBM_rim_core/lumosVar_rimcore/filteredVCF
OUTPUT_DIR=/scratch/speng/projects/IVY_GBM_rim_core/lumosVar_rimcore/filteredVCF
SCRIPTS='/scratch/speng/projects/IVY_GBM_rim_core/lumosVar_rimcore/filteredVCF'
COUNT=0

for sample in `find ${Location_DIR} -name "*filtered.vcf"`
do
       let COUNT=$COUNT+1
	   fileName=`basename $sample|cut -d. -f1`
	   pbsOutput="${OUTPUT_DIR}/${fileName}_snpEFF.out"
       read1=$sample
   
       qsub -N $fileName -o $pbsOutput -v INPUTVCF=$sample $SCRIPTS/snpEff_annotation.pbs
done

echo $COUNT
