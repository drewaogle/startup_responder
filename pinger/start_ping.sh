#start_ping.sh - start ping asynchronously

NO_USAGE=${NO_USAGE-}

if [ -z "${NO_USAGE}" ]; then
    echo "The application is reporting anonymous usage to ApertureData."
    echo "If you wish to turn this off, set the NO_USAGE environment variable to any value."

    bash /ping_process.sh | logger -t ping 2>&1 &

    MINUTE=$(shuf -i 0-59 -n 1)
    #(crontab -l 2>/dev/null; echo "$MINUTE */3 * * * /ping_process.sh") | crontab -
    (crontab -l 2>/dev/null; echo "* * * * * bash /ping_process.sh | logger -t ping 2>&1") | crontab -
fi
