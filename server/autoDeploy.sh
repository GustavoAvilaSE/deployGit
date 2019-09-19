#!/bin/bash

# *******************************************************************************************
# AutoDeploy: implementacao automatica depois de um reset ou restart do servico carte
#
# Copyright 2019 -  All rights reserved.
# *******************************************************************************************

#/*** INSTANCIAR VAIRAVEIS DE AMBIENTE ***/
WORK_FOLDER=/opt/pentaho/data-integration/autoDeploy
DEPLOY_ADDRESS=10.0.2.15
DEPLOY_PORT=8080
USER=cluster
PASS=cluster
#CONFIG_FILE=client1.deploy

# /*** OBTER LISTA DE ITENS A SEREM IMPLANTADOS ***/
#curl -H "Accept:application/vnd.github.v3.raw" -L https://raw.github.com/SoftExpertIntegrations/OnPremise-Config/master/$CONFIG_FILE --output $WORK_FOLDER/$CONFIG_FILE

# /*** OBTER ARQUIVOS FONTES DE ITENS A SEREM IMPLANTADOS ***/
#while read p; do
#    curl -H 'Accept:application/vnd.github.v3.raw' --remote-name -L $p
#done < $CONFIG_FILE

#/*** REGISTRAR JOBS E TRANSFORMATIONS NO SERVIDOR CARTE ***/
cd $WORK_FOLDER/sources

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
			echo curl -X POST -H "Content-Type: application/json"  -u $USER:$PASS -d @$i.xml http://$DEPLOY_ADDRESS:$DEPLOY_PORT/kettle/registerTrans/?xml=Y  >> $WORK_FOLDER/log/autoDeployTrans.log
			;;
		*.kjb)
			cp $i  $i.xml
			printf '%s\n' 1a '<job_configuration>' . x | ex $i.xml
			echo "<job_execution_configuration>
			<log_level>BASIC</log_level> 
			<safe_mode>N</safe_mode> 
			</job_execution_configuration> 
			</job_configuration>" >> $i.xml
			echo curl -X POST -H "Content-Type: application/json"  -u $USER:$PASS -d @$i.xml http://$DEPLOY_ADDRESS:$DEPLOY_PORT/kettle/registerJob/?xml=Y >> $WORK_FOLDER/log/autoDeployJobs.log				
			;;
	esac
done

#/*** INICIAR  JOBS E TRANSFORMATIONS NO SERVIDOR CARTE ***/
#while read i; do
for i in $(ls -C1)  
do
	echo $i
	file_name="${i##*/}"
	tmp=`sed -n 's/<name>\(.*\)<\/name>/\1/p' $file_name | head -1`	# /*** Linha para obter o nome do Job/Transformation ***/
	NAME=`echo $tmp | sed 's/ *$//g'` #/*** Linha pra apagar os espacos vacios ***/
	case $i in
		*.ktr)
			echo curl -X POST -H "Content-Type: application/json"  -u $USER:$PASS http://$DEPLOY_ADDRESS:$DEPLOY_PORT/kettle/prepareExec/?name=$NAME >>  $WORK_FOLDER/log/autoDeployTrans.log	
			#sleep 1
			echo url -X POST -H "Content-Type: application/json"  -u $USER:$PASS http://$DEPLOY_ADDRESS:$DEPLOY_PORT/kettle/startExec/?name=$NAME  >>  $WORK_FOLDER/log/autoDeployTrans.log
			;;
		*.kjb)
			echo curl -X POST -H "Content-Type: application/json"  -u $USER:$PASS http://$DEPLOY_ADDRESS:$DEPLOY_PORT/kettle/startJob/?name=$NAME >>  $WORK_FOLDER/log/autoDeployJobs.log	
			;;
	esac
#done < $CONFIG_FILE
done

#/*** EXCLUIR ARQUIVOS TEMPORARIOS ***/
#find . -name "*.xml" -type f -delete
#find . -name "*.ktr" -type f -delete
#find . -name "*.kjb" -type f -delete	
#rm -f $CONFIG_FILE

