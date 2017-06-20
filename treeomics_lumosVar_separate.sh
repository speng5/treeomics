#!/bin/bash
###Author:Sen Peng
###


outputDir=/scratch/speng/projects/IVY_GBM_rim_core/lumosVar_rimcore/treeomics_input
for file in `find /scratch/speng/projects/IVY_GBM_rim_core/lumosVar_rimcore/filteredVCF -name "*.vcf"|sort`
do
fileName=`basename $file|cut -d. -f1`
output1=${outputDir}/${fileName}_mutant_reads.txt
output2=${outputDir}/${fileName}_phredcoverage.txt
>${output1}
>${output2}

echo ${fileName}

MATRIX=$file
totalField=`awk 'END {print NF}' $file`
let noField=${totalField}-11

#if [ $noField -eq 3 ]
#then
#header="Chromosome\tPosition\tChange\tGene\t${fileName}_CORE\t${fileName}_R1\t${fileName}_R2"
#else
#header="Chromosome\tPosition\tChange\tGene\t${fileName}_CORE\t${fileName}_R1"
#fi

#echo -e "$header" >> ${output1}
#echo -e "$header" >> ${output2}

date
echo "Start treeomics coverage and mutation"
while read -r line
do
prefix=`echo "$line"|awk -F$'\t' '{printf $1"\t"$2"\t"$4">"$5"\t""NA"}'`
for ((i=0;i<$noField;i++))
        do
       let currField=${i}+11
       coverInput=`echo "$line"|awk -F$'\t' -v currField=$currField '{print $currField}'|cut -d: -f3`
       ref=`echo $coverInput|cut -d, -f1`
	alt=`echo $coverInput|cut -d, -f2`
	let total=$ref+$alt
   if [ $i -eq 0 ]
	then
	header="${fileName}_CORE\t"
  elif [ $i -eq 1 ]
        then
	header="${fileName}_R1\t"
  else
   	header="${fileName}_R2\t"
	fi
echo -ne "${header}" >> ${output1}
echo -ne "${header}" >> ${output2}
echo -ne "${prefix}" >> ${output1}
echo -ne "${prefix}" >> ${output2}
	echo -e "\t$alt" >> ${output1}
        echo -e "\t$total" >> ${output2}
done
done < ${MATRIX}

done


echo "End treeomics coverage and mutation"
date
