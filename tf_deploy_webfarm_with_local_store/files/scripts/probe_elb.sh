#!/bin/bash 
# args: 
# $(terraform state show $(terraform state list | grep elb) | grep dns_name | awk '{print $3}'|sed -e 's/\"//g') 
# 8080
# 1

#set -euo pipefail

export PATH="/usr/bin:/usr/sbin/:${PATH}"

ELB=${1:-"NONE"}
PORT=${2:-"8080"}
PROBE_COUNT=${3:-"50"}

_probe_elb()
{
if [ ${1} = "NONE" ]; then
	exit 1
fi

while [ ${PROBE_COUNT} -lt 50 ]
do
	wget -q ${1}:${2}
	if [ -f index.html ]; then
		echo "$(grep -i address index.html | cut -d '[' -f2|cut -d ']' -f1)"
		rm index.html*
	else
		echo "no ./index.html"
	fi

	PROBE_COUNT=$((PROBE_COUNT + 1))
done
}

_probe_elb ${ELB} ${PORT}
