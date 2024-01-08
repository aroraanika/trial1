#!/bin/bash


for phys in nsaszc ; do

 year=2003
 mon=06
 day=05      # if less than 10 give two digit
 cycle=00
 while [ $year -le 2019 ]; do

  en=0
      current_dir=$PWD
      PDY=${year}${mon}${day}

	while [ $en -le 3 ]; do
           if [ $en -lt 10 ]; then en1=0$en ; fi
           if [ $en -ge 10 ]; then en1=$en ; fi

        JCAP=382
	expt_name=IMDERP_hind_GFS_${phys}_${JCAP}_${PDY}${cycle}_en${en1}_erp
	output=/home/ERPAS/imdoper/model_output/raw_data/${expt_name}

	      nfiles=$(ls -1 $output/pgbf* |wc -l) 
              echo 'files in T382' ${phys} ${PDY} and ${en1} is $nfiles

        JCAP=126
	expt_name=IMDERP_hind_GFS_${phys}_${JCAP}_${PDY}${cycle}_en${en1}_erp
	output=/home/ERPAS/imdoper/model_output/raw_data/${expt_name}

	      nfiles=$(ls -1 $output/pgbf* |wc -l) 
              echo 'files in T126' ${phys} ${PDY} and ${en1} is $nfiles

  en=$(( $en + 1 ))
  done  

 year=$(( $year + 1 ))
 done
sleep 1
done

echo 'Done with missing hindcast runs'

