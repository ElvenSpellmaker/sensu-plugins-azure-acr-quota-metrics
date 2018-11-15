#!/bin/bash

ENV_DIR="/az-python"

while getopts c:i:p:t: option
do
	case "${option}"
	in
		c) AZ_COMMAND=${OPTARG};;
		i) SPN_ID=${OPTARG};;
		p) SPN_SECRET=${OPTARG};;
		t) TENANT_ID=${OPTARG};;
	esac
done

. $ENV_DIR/bin/activate &> /dev/null

az login --service-principal -u "$SPN_ID" -p "$SPN_SECRET" --tenant "$TENANT_ID" &> /dev/null

eval az $AZ_COMMAND
