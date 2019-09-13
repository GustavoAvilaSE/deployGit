#!/bin/bash

# *******************************************************************************************
# Deploy integrations routines on premise
#
# Copyright 2019 -  All rights reserved.
# *******************************************************************************************

ROOT_FOLDER=/opt/pentaho/data-integration/autoDeploy

# /*** OBTER INFORMACAO DE CONFIGURACAO DO REPOSTIORIO ***/
curl -H "Accept:application/vnd.github.v3.raw" -L https://raw.github.com/SoftExpertIntegrations/OnPremise-Config/master/client1.deploy --output client1.deploy
#wget --spider --http-user=cluster --http-password=cluster0908 http://52.67.35.163/kettle/executeJob/?job=$jobs

