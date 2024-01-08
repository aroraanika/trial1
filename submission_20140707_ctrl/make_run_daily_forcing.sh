#!/bin/bash
########################################################################
## The post-processing script is different and not mixed with this    ##
####################    Phani Feb 2019  ################################

########################################################################
############ Change the following for the Forecast #####################
############  1) year 2) mon 3) day 4) en          #####################
#########################################################################
set -x
 EXPTRUN=GFS

  year=2014
  mon=7
  day=7
  cycle=00
  current_dir=$PWD
  JCAP=126    # Start of First Resolution
  #len_1=7350    # No of days for first Segment
  #len_1=15000    # No of days for first Segment
  #len_1=3650    # No of days for first Segment
#len_1=1000
#len_1=16425

## len_1-16425 days means 45*365
 nprocs=360

len_1=10


  if [ $day -lt 10 ]; then day=0$day ; fi
  if [ $mon -lt 10 ]; then mon=0$mon ; fi

  PDY=${year}${mon}${day}
  sdate=${mon}${day}
  yr=`echo $year| cut -c3-4`
#echo $PDY


 # define the paths script-->submission ;expt_name--> tmp dir; output--> Output path 
 # IC directory
#ic_dir=/home/DESK/anika/GFS-EL/intel/17.0.5/GFS/IC
#  expt_dir=/home/DESK/anika/GFS-EL/gfs_pratyush/work
 #ic_dir=/home/DESK/anika/GFS-EL/intel/17.0.5/GFS/IC1
 ic_dir=/home/DESK/anika/IC_2014070700
  #expt_dir=/home/DESK/anika/GFS-EL/gfs_pratyush/work_ctrl_20140707

  expt_dir=/home/DESK/anika/GFS-EL/gfs_pratyush/daily_ICs_work_ctrl_20140707
  #expt_dir=/home/DESK/anika/GFS-EL/gfs_pratyush/TEST_WORK

#  for JCAP in 382 126 
  for JCAP in 382
  do
        if [[ $JCAP == "382" ]] ; then
            lonb=1152 ; latb=576  ; timestep=300
         fi
        if [[ $JCAP == "126" ]] ; then
            lonb=384  ; latb=190 ; timestep=600
         fi


#  forcingfile=/home/ERPAS/imdoper/model_output/EXTRACT_IMDERP/CFST${JCAP}/crcbias_sst/${sdate}/sst/bias_crctd_sst_${sdate}_${year}.grb

      jcap1=`echo $JCAP| cut -c1`
      JB_NAME=GE${yr}${sdate}.${JCAP}

      expt_name=${EXPTRUN}_${JCAP}_${PDY}${cycle}
      script=${expt_dir}/ptmp/script_resol${EXPTRUN}/${expt_name}
      echo $script
      file_name=gfs_config_${JCAP}_${PDY}${cycle}
      output=${expt_dir}/${expt_name}
      tmppath=${expt_dir}/tmp/${expt_name}

      mkdir -p $script
  if [ -d ${output} ] ; then rm -rf ${output} ; fi
#       if [ -d ${tmppath} ] ; then rm -rf ${tmppath} ; fi
	  mkdir -p ${output} 
      #cp ${ic_dir}/cdas.${PDY}/cdas1.t00z.sanl $output/siganl.gfs.${PDY}${cycle}
      #cp ${ic_dir}/cdas.${PDY}/cdas1.t00z.sfcanl $output/sfcanl.gfs.${PDY}${cycle}
     

	#cp ${ic_dir}/gdas.${PDY}/cdas1.t00z.sanl $output/siganl.gfs.${PDY}${cycle}
      #cp ${ic_dir}/gdas.${PDY}/cdas1.t00z.sfcanl $output/sfcanl.gfs.${PDY}${cycle}
#             sfcanl.gfs.2014070700  siganl.gfs.2014070700
     

####              Revised ICs ANIKA taken from Phani
      cp ${ic_dir}/siganl.gfs.${PDY}${cycle} $output/siganl.gfs.${PDY}${cycle}
      cp ${ic_dir}/sfcanl.gfs.${PDY}${cycle} $output/sfcanl.gfs.${PDY}${cycle}
   
      #cp ${ic_dir}/gdas.${PDY}/cdas1.t00z.sfcanl $output/sfcanl.gfs.${PDY}${cycle}

sleep 1

	  echo $expt_dir
	  sed "s+tmpdir+$tmppath+" JGFS_FORECAST_LOW >temp1
	  sed -i "s/PDYDATE/$PDY/" temp1  
      sed -i "s/jcap/$JCAP/" temp1
      sed -i "s/lonb/$lonb/" temp1
      sed -i "s/latb/$latb/" temp1
      sed -i "s/timestep/$timestep/" temp1
	  sed -i "s+forecast_script+$script+" temp1
	  sed -i "s/cycleforecast/$cycle/" temp1
      sed -i "s/exptic/$EXPTRUN/" temp1
      sed -i "s/file1/$file_name/" temp1
	  sed "s+outpath+$output+" temp1>$script/JGFS_FORECAST_${expt_name}
	  sed "s+forecast_dir+$expt_dir+" gfs_config_orig >temp 
	  sed -i "s+forecast_script+$script+" temp
	  sed -i "s+resol+$JCAP+" temp
	  sed -i "s+nprocs+$nproc+" temp
      sed -i "s+exptic+$EXPTRUN+" temp
	  sed "s+outputpath+$output+" temp>$script/${file_name}
	  file2=JGFS_FORECAST_${expt_name}
      sed "s+scriptdir+$script+" submit_gfs_fcst.pbs > $script/submit_gfs_fcst_${expt_name}.ll
	  sed -i "s+JOBNAME+$JB_NAME+" $script/submit_gfs_fcst_${expt_name}.ll
	  sed -i "s+filesubmit+$file2+" $script/submit_gfs_fcst_${expt_name}.ll
	  sed -i "s+cfssubmit+$file_name+" $script/submit_gfs_fcst_${expt_name}.ll
	  sed -i "s+jcap+$JCAP+" $script/submit_gfs_fcst_${expt_name}.ll
	  sed -i "s+len1+$len_1+" $script/submit_gfs_fcst_${expt_name}.ll
                
	rm -rf temp temp1
	cd $script
#        exit
	chmod +x *
      # Submit to the job queue
        sleep 1
        qsub submit_gfs_fcst_${expt_name}.ll

	cd $current_dir 

  done   # resol loop 



