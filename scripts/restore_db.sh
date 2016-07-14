#!/bin/bash

if [ $# -lt 2 ] ; then
  echo -ne "Usage: `basename $0` DATABASE DUMP_FILE\n\n"
  echo "Restores a local database from a dump file"
  echo "Parameters:"
  echo "    DATABASE: database to restore into"
  echo "    DUMP_FILE: dump file to restore"
  exit 1
fi

DB=$1
IN_FILE=$2
CUR_DATE=`date +%F_%H.%M.%S`

if [ ! -f restore_tables ] ; then
  echo "Missing config file 'restore_tables', containing the list of tables to restore."
  exit 1
fi

if [ "$(psql -l|grep "^\s*$DB\s*|"|cut -d '|' -f 1|sed -e 's/\W//g')" != "$DB" ]; then
  echo "Database does not exist; here's the list of databases:"
  psql -l
  exit 2
fi

if [ ! -f $IN_FILE ] ; then
  echo "Input file $IN_FILE does not exist."
  exit 3
fi

pg_restore -d $DB --schema-only -v $IN_FILE 2>&1 > db_restore_${CUR_DATE}.log
while read TABLE ; do
  pg_restore -d $DB -t $TABLE -a -v $IN_FILE 2>&1 >> db_restore_${CUR_DATE}.log
done < restore_tables

echo "Done restoring. Please check db_restore_${CUR_DATE}.log for any errors."
