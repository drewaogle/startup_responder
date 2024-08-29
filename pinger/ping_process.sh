#ping_process.sh - ping url with anonymous usage data

# don't update files on error.
set -e

echo "Starting Ping Attempt"

PING_URL="http://stats:5000/ping"
# tracks # of pings
PING_COUNT_FILE="/tmp/ping_count"
# tracks last ping
LAST_USAGE_FILE="/tmp/ping_date"
# tracks when container started.
UPTIME_FILE="/tmp/container_start"
# ping diff sec - amount of time between last ping before trying ping again.
# this ensures a max rate on pings.
PING_DIFF_SEC=$(( 60*60 )) # 1 hr
PING_DIFF_SEC=$(( 30 ))

CUR_UPTIME=$(printf "%0.0f" "$(cat /proc/uptime | cut -d' ' -f1)")
CURRENT_TIME=$( date +%s )
# cacluated
UPTIME_SEC=


DUE_FOR_PING=
PING_COUNT=0

if [ -e ${LAST_USAGE_FILE} ]; then
    LAST=$(cat ${LAST_USAGE_FILE})
    NEXT=$(( $LAST + $PING_DIFF_SEC ))

    if [[ $CURRENT_TIME -gt $NEXT ]]; then
        DUE_FOR_PING=1
    fi
    UPTIME_SEC=$(( $CURRENT_TIME - $( stat -c %W "${PING_COUNT_FILE}") ))
else
    UPTIME_SEC=0
    DUE_FOR_PING=1
fi

if [ -e "${UPTIME_FILE}" ]; then
    UPTIME_SEC=$(( $CUR_UPTIME - $(cat "${UPTIME_FILE}") ))
else
    UPTIME_SEC=0
    echo "$CUR_UPTIME" > "${UPTIME_FILE}"
fi

if [ -e ${PING_COUNT_FILE} ]; then
    PING_COUNT=$(cat ${PING_COUNT_FILE})
fi
echo "Ping Info Ready"
if [ -z "${NO_USAGE}" -a ! -z "${DUE_FOR_PING}"  ]; then
    echo "curling ${PING_URL}"
    curl -s -d "count=$PING_COUNT" -d "uptime=$UPTIME_SEC" "$PING_URL"
    echo $CURRENT_TIME > "$LAST_USAGE_FILE"
    echo $(( $PING_COUNT + 1 )) > "$PING_COUNT_FILE"
    echo "Ping Successful"
else
    echo "No Ping Needed"
fi
