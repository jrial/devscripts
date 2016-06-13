#!/usr/bin/env bash
SCRIPT_PATH="${HOME}/.devscripts"
BASE_DIR="${SCRIPT_PATH}/schemaSpy"

if [ ! -d "${BASE_DIR}" ] ; then
	mkdir "${BASE_DIR}"
fi
JAR_PATH="${BASE_DIR}/schemaSpy_latest.jar"

if [ ! -f "${JAR_PATH}" ] ; then
	wget 'https://sourceforge.net/projects/schemaspy/files/latest/download?source=files' -O "${JAR_PATH}"
fi

# Check Java version - we need the correct JDBC driver in function of our version of Java.
if [ ! -x "`which java`" ] ; then
    echo "This application requires Java."
    echo "Please install Java before proceeding, and make sure it's on the path."
    exit 1
fi
# Found on http://stackoverflow.com/a/37593973/669473
JAVA_VER_MAJOR=""
JAVA_VER_MINOR=""
JAVA_VER_BUILD=""
for token in $(java -version 2>&1 | grep -i version) ; do
    if [[ $token =~ \"([[:digit:]])\.([[:digit:]])\.(.*)\" ]] ; then
        JAVA_VER_MAJOR=${BASH_REMATCH[1]}
        JAVA_VER_MINOR=${BASH_REMATCH[2]}
        JAVA_VER_BUILD=${BASH_REMATCH[3]}
        break
    fi
done


if [ "$JAVA_VER_MAJOR" == "1" ] ; then
	if [ "$JAVA_VER_MINOR" == "6" ] ; then
		JDBC_FILE="postgresql-9.4.1208.jre6.jar"
	elif [ "$JAVA_VER_MINOR" == "7" ] ; then
	    JDBC_FILE="postgresql-9.4.1208.jre7.jar"
	elif [ "$JAVA_VER_MINOR" == "8" ] ; then
	    JDBC_FILE="postgresql-9.4.1208.jar"
    else
		echo "Either you have an outdated Java version, or there's a newer version than Java 1.8."
		echo "Your Java version is: ${JAVA_VER_MAJOR}.${JAVA_VER_MINOR].{JAVA_VER_BUILD}"
		echo "If it's newer than Java 1.8, check https://jdbc.postgresql.org/download.html"
		echo "for an entry for your version, and update this script."
		echo
		echo "I'll assume it's 1.5 or lower, and install the correct JDBC driver for that version."
		JDBC_FILE="postgresql-9.3-1103.jdbc3.jar"
	fi
	JDBC_PATH="${BASE_DIR}/${JDBC_FILE}"
	if [ ! -f "${JDBC_PATH}" ] ; then
		wget "https://jdbc.postgresql.org/download/${JDBC_FILE}" -O "${JDBC_PATH}"
	fi
else
	echo "Either something's wrong, or this is the future (relative to when I wrote"
	echo "this; you're obviously reading this in the present). Your Java major"
	echo "version is '${JAVA_VER_MAJOR}', which is disctinctly different from '1'."
	exit 1
fi

# Verify graphviz
if [ ! -f "`which dot`" ] ; then
	echo "Running 'sudo apt-get install graphviz'. It may ask for your sudo password."
	sudo apt-get install graphviz
fi

# Check settings
SETTINGS_PATH="${SCRIPT_PATH}/settings/schemaSpy"
if [ ! -f "${SETTINGS_PATH}" ] ; then
	echo "Please create a settings file at ${SETTINGS_PATH}"
	echo "See the example in ${SETTINGS_PATH}.example"
	exit 1
fi

# Load settings
. "${SETTINGS_PATH}"

# Finally, run this thing.
if [ "$#" -ne 2 ] ; then
	echo "Usage: $0 <database> <output_path>"
	exit 1
fi

DB=$1
OUTPUT_PATH=$2

java -jar ${JAR_PATH} -t pgsql -dp ${JDBC_PATH} -o ${OUTPUT_PATH}/ -u ${DB_USER} -host localhost -db ${DB} -p ${DB_PASS} -s public \
&& ${BROWSER_COMMAND} ${OUTPUT_PATH}/index.html
