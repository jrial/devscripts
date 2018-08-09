#!/bin/bash

if [ $# -lt 1 ] ; then
	echo -ne "Usage: `basename $0` PFX_FILE\n\n"
	echo "Parameters:"
	echo "    PFX_FILE: certificate input file in PFX format"
	exit 1
fi

IN_FILE=$1
IN_FILE_BASE=`echo $IN_FILE | sed -e 's/\.pfx//i'`

openssl pkcs12 -in "${IN_FILE}" -out "${IN_FILE_BASE}.crt" -nodes -nokeys
openssl pkcs12 -in "${IN_FILE}" -out "${IN_FILE_BASE}.key" -nocerts
openssl rsa -in "${IN_FILE_BASE}.key" -out "${IN_FILE_BASE}.nocrypt.key"

echo -ne "Done. You can now deploy ${IN_FILE_BASE}.crt and "
echo "${IN_FILE_BASE}.nocrypt.key to your server."
