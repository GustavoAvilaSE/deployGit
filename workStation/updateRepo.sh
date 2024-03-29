#!/bin/bash

# *******************************************************************************************
# Deploy integrations routines on premise
#
# Copyright 2019 -  All rights reserved.
# *******************************************************************************************

# /*** GITHUB CONFIG VARIABLES ***/
GIT_USER_NAME=testRepo
GIT_EMAIL=gustavo.avila@softexpert.com
GITHUB_ORGANIZATION=GustavoAvilaSE
GITHUB_REPOSITORY_NAME=testRepo
SOURCE_FOLDER=/opt/pentaho/data-integration/workStation/sources
REPO_EXIST=false

cd $SOURCE_FOLDER

for i in $(ls -C1)  
do 
	if [ -e ".git" ] 
	then		
		REPO_EXIST=true
		break;
	fi
done

# *** VERIFIES IF IS A NEW REPOSITORY OR AN EXISTING ONE ***
if  $REPO_EXIST ;
then
    # *** MAKE A PULL, ADD AND COMMIT FORM LOCAL REPOSITORY TO A REMOTE GITHUB REPOSITORY ***   
    git config --local user.name $GIT_USER_NAME
    git config --local user.email $GIT_EMAIL
    git pull origin master
    git add .
    git commit -m "Update sources from Consultor Workstation"
    git push origin master
else
    # *** CREATE LOCAL REPOSITORY AND ASOCIATE IT A REMOTE GITHUB REPOSITORY ***
    git init 
    git config --local user.name $GIT_USER_NAME
    git config --local user.email $GIT_EMAIL
    git remote add origin  https://github.com/$GITHUB_ORGANIZATION/$GITHUB_REPOSITORY_NAME 
    git pull origin master
    # git config --local credential.helper "store --file %~dp0/deploy/config/gitcredential"
    git add .
    git commit -m "Initial Upload from Consultor Workstation"
    git push origin master
fi	











