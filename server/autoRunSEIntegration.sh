#!/bin/bash

# *******************************************************************************************
# AutoRunSEIntegration: Començo automático do Carte e das integrações implementadas 
#
# Copyright 2019 -  All rights reserved.
# *******************************************************************************************

#/*** INSTANCIAR VAIRAVEIS DE AMBIENTE ***/
WORK_FOLDER=/opt/pentaho/data-integration
SERVICE_ADDRESS=10.0.2.15
SERVICE_PORT=8080
SERVICE_PROCESS_NUMBER=null

# /*** INICIALIZAR CARTE ***/
#TIME_STAMP=`date+"%m-%d-%Y-%H:%M:%s"`
#echo '/****************************
#       ***  START ON $TIME_STAMP *** 
#       *****************************/' >>$WORK_FOLDER/server/log/carteAutoRun.log

nohup $WORK_FOLDER/carte.sh $SERVICE_ADDRESS $SERVICE_PORT &>>$WORK_FOLDER/server/log/carteAutoRun.log &

while :; do
	SERVICE_PROCESS_NUMBER=`ps -ef | grep launcher.jar | grep -v grep | awk '{print $2}'`
	if [ ! -z $SERVICE_PROCESS_NUMBER ] 
	then
		# /*** IMPLANTAR SO DEPOIS DE START O CARTE SERVICE ***/
		nohup $WORK_FOLDER/server/autoDeploy.sh &>/dev/null &
		break;
	fi
done
