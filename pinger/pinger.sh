#pinger.sh - ping url with anonymous usage data
PING_URL="https://aperturedata.io/usage.py"
PING_COUNT_FILE="/tmp/ping_count"
LAST_USAGE_FILE="/tmp/ping_date"
PING_DIFF_SEC=$(( 60*60 ))

NO_USAGE=${NO_USAGE-}

CURRENT_TIME=$( date +%s )

DUE_FOR_PING=
PING_COUNT=0

if [ -e ${LAST_USAGE_FILE} ]; then
    LAST=$(cat ${LAST_USAGE_FILE})
    NEXT=$(( $LAST + $PING_DIFF_SEC ))

    if [[ $CURRENT_TIME -gt $NEXT ]]; then
        DUE_FOR_PING=1
    fi
fi

if [ -e ${PING_COUNT_FILE} ]
    PING_COUNT=$(cat ${PING_COUNT_FILE})
fi


if [ -z "${NO_USAGE}" -a ! -z "${DUE_FOR_PING}"  ]; then
    echo "The application is reporting anonymous usage to ApertureData."
    echo "If you wish to turn this off, set the NO_USAGE environment variable to any value."

    curl -d "count=$PING_COUNT" "$PING_URL"
    echo $CURRENT_TIME > "$LAST_USAGE_FILE"
    echo $(( $PING_COUNT + 1 )) > "$PING_COUNT_FILE"
fi
