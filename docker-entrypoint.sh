#!/bin/bash

set -Eeuo pipefail

_gendh() {
	local size=$1 genval=$2 filename=$3 user=$4 group=$5 mod=$6
	filename="$(printf "${filename}" "${size}")"
	tmpfile="$(mktemp)"
	openssl gendh -${genval} -out "${tmpfile}" ${size} >/dev/null 2>&1
	mv "${tmpfile}" "/data/${filename}"
	chown ${user}:${group} "/data/${filename}"
	chmod ${mod} "/data/${filename}"
	echo "New parameters for ${filename} generated."
}

DH=($(echo ${DH} | tr ';' ' '))
TIMEOUT=${TIMEOUT:-86400}
FILENAME=${FILENAME:-dh%s.pem}
USER=${USER:-root}
GROUP=${GROUP:-root}
CHMOD=${CHMOD:-0640}

while true; do
	for dh in ${DH[@]}; do
		if [[ "${DH}" == *":"* ]]; then
			tmp_dh=($(echo ${dh} | tr ':' ' '))
			size=${tmp_dh[0]}
			genval=${tmp_dh[1]}
		else
			size=${dh}
			genval=2
		fi
		_gendh ${size} ${genval} ${FILENAME} ${USER} ${GROUP} ${CHMOD} &
	done
	wait
	[[ ${TIMEOUT} == "0" ]] && break
	sleep ${TIMEOUT}
done
