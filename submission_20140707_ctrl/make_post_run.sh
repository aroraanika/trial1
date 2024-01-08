#!/bin/bash
year=2014
mon=07
day=7
cycle=00
current_dir=$PWD

#for JCAP in  126 382
JCAP=382 
   if [ $day -lt 10 ]; then day=0$day ; fi
        PDY=${year}${mon}${day}
        cd $current_dir 
   	#length=33 ;NPROC_O=72; NPROC_C=1 ;NPROC_A=90 ;FHINI=00; nodes=8
   	length=1 ;NPROC_O=72; NPROC_C=1 ;NPROC_A=90 ;FHINI=00; nodes=8
        expt_name=GFS_${JCAP}_${PDY}${cycle}
        expt_dir=/home/DESK/anika/GFS-EL/gfs_pratyush/work_ctrl_20140707/tmp/${expt_name}
        script=/home/DESK/anika/GFS-EL/gfs_pratyush/work_ctrl_20140707/ptmp/script_resol_GFS/${expt_name}
        echo $script
	mkdir -p $script
        file_name=gfs_config_${JCAP}_${PDY}${cycle}
        output=/home/DESK/anika/GFS-EL/gfs_pratyush/work_ctrl_20140707/${expt_name}
        tmppath=${expt_dir}/tmp/${expt_name}
		mkdir -p ${expt_dir} 
		mkdir -p ${output} 
        mkdir -p $script
		echo $expt_dir
        echo $output
		sed "s+hind_dir+$expt_dir+" JGFS_POST >temp2
		sed "s+outpath+$output+" temp2 >temp1
		sed -i "s/PDYDATE/$PDY/" temp1  
		sed -i "s+hind_script+$script+" temp1
		sed -i "s/cyclehind/$cycle/" temp1
		sed "s+file1+$file_name+" temp1>$script/JGFS_POST_${JCAP}_${PDY}_${cycle}
		sed "s+hind_dir+$expt_dir+" gfs_config_orig >temp 
		sed -i "s+hind_script+$script+" temp
		sed -i "s+resol+$JCAP+" temp
		sed -i "s+length_day+$length+" temp
		sed "s+outputpath+$output+" temp>$script/${file_name}
		file2=JGFS_POST_${JCAP}_${PDY}_${cycle}
        sed "s+ens+$en1+" submit_post.pbs > $script/submit_post_${JCAP}.pbs
		sed -i "s+filesubmit+$file2+" $script/submit_post_${JCAP}.pbs
		sed -i "s+jcap+$JCAP+" $script/submit_post_${JCAP}.pbs
		sed -i "s+len_1+$length+" $script/submit_post_${JCAP}.pbs
		sed -i "s+scripta+$script+" $script/submit_post_${JCAP}.pbs

		rm -rf temp temp1 temp2
		cd $script
		chmod +x *
                sleep 2


		   qsub ./submit_post_${JCAP}.pbs 

		cd $current_dir 


               sleep 2 

