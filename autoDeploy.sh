#!/bin/bash

# *******************************************************************************************
# Deploy integrations routines on premise
#
# Copyright 2019 -  All rights reserved.
# *******************************************************************************************

ROOT_FOLDER=/opt/pentaho/data-integration/autoDeploy
DEPLOY_ADDRESS=10.0.2.15
DEPLOY_PORT=8080
USER=cluster
PWD=cluster

# /*** OBTER INFORMACAO DE CONFIGURACAO DO REPOSTIORIO ***/
#curl -H "Accept:application/vnd.github.v3.raw" -L https://raw.github.com/SoftExpertIntegrations/OnPremise-Config/master/client1.deploy --output $ROOT_FOLDER/client1.deploy
#wget --spider --http-user=cluster --http-password=cluster0908 http://52.67.35.163/kettle/executeJob/?job=$job

#while read p; do
#	    curl -H 'Accept:application/vnd.github.v3.raw' --remote-name -L $p
#done < client1.deploy

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
			curl -X POST -H "Content-Type: application/json"  -u $USER:$PWD -d @$i.xml http://$DEPLOY_ADDRESS:$DEPLOY_PORT/kettle/registerTrans/?xml=Y  >> autoDeployTrans.log
			;;
		*.kjb)
			cp $i  $i.xml
			printf '%s\n' 1a '<job_configuration>' . x | ex $i.xml
			echo "<job_execution_configuration>
			<log_level>BASIC</log_level> 
			<safe_mode>N</safe_mode> 
			</job_execution_configuration> 
			</job_configuration>" >> $i.xml
			curl -X POST -H "Content-Type: application/json"  -u $USER:$PWD -d @$i.xml http://$DEPLOY_ADDRESS:$DEPLOY_PORT/kettle/registerJob/?xml=Y >> autoDeployJobs.log
			;;
	esac
done

find . -name "*.xml" -type f -delete
find . -name "*.ktr" -type f -delete
find . -name "*.kjb" -type f -delete	
find . -name "*.deploy" -type f -delete
#while read p; do

#	echo $p >> $i.xml
	#if [$first_line=1] ; then
        #if [[ $first_line=1 ]] ; then
	#	echo "<transformation_configuration>"  >> $i.xml
	#	first_line=0
	#fi
	
#done < $i

#while read p; do

#  case $p in
#	*.ktr)
#		echo "Case 1 "$p

#		;;
#	*.kjb)
#		echo "Case 2 "$p
		#break
#		;;
#  esac

#done < client1.deploy

#if [[ $p =~ ".ktr" ]] then
#   echo $p
#fi
#if [[ $p =~ ".kjb" ]] then
#   echo $p
#fi
