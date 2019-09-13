#!/bin/bash

# *******************************************************************************************
# Deploy integrations routines on premise
#
# Copyright 2019 -  All rights reserved.
# *******************************************************************************************

WORK_FOLDER=/opt/pentaho/data-integration/autoDeploy
DEPLOY_ADDRESS=10.0.2.15
DEPLOY_PORT=8080
USER=cluster
PWD=cluster
CONFIG_FILE=client1.deploy

# /*** OBTER INFORMACAO DE CONFIGURACAO DO DEPLOY ***/
curl -H "Accept:application/vnd.github.v3.raw" -L https://raw.github.com/SoftExpertIntegrations/OnPremise-Config/master/$CONFIG_FILE --output $WORK_FOLDER/$CONFIG_FILE

while read p; do
    curl -H 'Accept:application/vnd.github.v3.raw' --remote-name -L $p
done < $CONFIG_FILE

for i in $(ls -C1)  
do
	
	case $i in
		*.ktr)
			cp $i  $i.xml
			printf '%s\n' 1a '<transformation_configuration>' . x | ex $i.xml
			echo "<transformation_execution_configuration> 
			<log_level>BASIC</log_level> 
			<safe_mode>N</safe_mode> 
			</transformation_execution_configuration> 
			</transformation_configuration>" >> $i.xml

			curl -X POST -H "Content-Type: application/x-www-form-urlencoded"  -u $USER:$PWD -d @$i.xml http://$DEPLOY_ADDRESS:$DEPLOY_PORT/kettle/registerTrans/?xml=Y  >> autoDeployTrans.log
			#sleep 5
			#echo basename -s .ktr "$i" >
			#echo "$i" | cut -f 1 -d '.'
			#echo $name
			#echo ${i##.ktr/}
			#echo $trans_name 
			;;
		*.kjb)
			cp $i  $i.xml
			printf '%s\n' 1a '<job_configuration>' . x | ex $i.xml
			echo "<job_execution_configuration>
			<log_level>BASIC</log_level> 
			<safe_mode>N</safe_mode> 
			</job_execution_configuration> 
			</job_configuration>" >> $i.xml

			#echo curl -X POST -H "Content-Type: application/json"  -u $USER:$PWD -d @$i.xml http://$DEPLOY_ADDRESS:$DEPLOY_PORT/kettle/registerJob/?xml=Y >> autoDeployJobs.log				
			;;
	esac
done

while read i; do
	case $i in
		*.ktr)
			file_name="${i##*/}"
			TRANS_NAME="${file_name%.*}"
			#echo curl -X POST -H "Content-Type: application/x-www-form-urlencoded"  -u $USER:$PWD http://$DEPLOY_ADDRESS:$DEPLOY_PORT/kettle/prepareExec/?name=$TRANS_NAME >> autoDeployTrans.log
			#sleep 5
			#echo curl -X POST -H "Content-Type: application/x-www-form-urlencoded"  -u $USER:$PWD http://$DEPLOY_ADDRESS:$DEPLOY_PORT/kettle/startExec/?name=$TRANS_NAME  >> autoDeployTrans.log
			;;
		*.kjb)
			file_name="${i##*/}"
			JOB_NAME="${file_name%.*}"			
			#echo curl -X POST -H "Content-Type: application/json"  -u $USER:$PWD http://$DEPLOY_ADDRESS:$DEPLOY_PORT/kettle/startJob/?name=$JOB_NAME >> autoDeployJobs.log	
			;;
	esac
done < $CONFIG_FILE





#find . -name "*.xml" -type f -delete
#find . -name "*.ktr" -type f -delete
#find . -name "*.kjb" -type f -delete	
#rm -f $CONFIG_FILE

