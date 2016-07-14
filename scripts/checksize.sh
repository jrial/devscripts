#!/bin/bash

if [ $# -lt 1 ] ; then
  echo -ne "Usage: `basename $0` DATABASE [NUM]\n\n"
  echo "Lists the largest tables in your database."
  echo "Parameters:"
  echo "    DATABASE: database to connect to"
  echo "    NUM: number of tables to show (default: 20)"
  exit 1
fi

DB=$1

if [ "$(psql -l|grep "^\s*$DB\s*|"|cut -d '|' -f 1|sed -e 's/\W//g')" != "$DB" ]; then
  echo "Database does not exist; here's the list of databases:"
  psql -l
  exit 2
fi

# Checks whether there is a second parameter and whether it's numeric.
if [[ $# -eq 2 && $2 -eq $2 ]] ; then
  NUM=$2
else
  NUM=20
fi

psql $DB << EOF
SELECT nspname || '.' || relname AS "relation",
    pg_size_pretty(pg_total_relation_size(C.oid)) AS "total_size"
  FROM pg_class C
  LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
  WHERE nspname NOT IN ('pg_catalog', 'information_schema')
    AND C.relkind <> 'i'
    AND nspname !~ '^pg_toast'
  ORDER BY pg_total_relation_size(C.oid) DESC
  LIMIT $NUM;
EOF
