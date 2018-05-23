
set -x

URI_SCHEMA=${URI_SCHEMA:-http}
SLAVE_URL=${MESOS_AGENT_ENDPOINT%:*}
HEALTH_PATH=${HEALTH_PATH:-/health}
UNKNOWN_CODE=${UNKNOWN_CODE:-503}

APP_DIRECTORY=/tmp$MARATHON_APP_ID
STATUS_DIRECTORY=$APP_DIRECTORY/$MESOS_TASK_ID

mkdir -p $STATUS_DIRECTORY

echo "$HOST:$PORT0"

CODE=$(curl -s -o /dev/null -w %{http_code} $URI_SCHEMA://$SLAVE_URL:$PORT0$HEALTH_PATH)

if [ $CODE -ge 200 -a $CODE -lt 300 ]
then
  echo 0 > $STATUS_DIRECTORY/status
else
  if [ $CODE -eq $UNKNOWN_CODE ]
  then
    if [ ! -f $STATUS_DIRECTORY/status ]
    then
      echo 1 > $STATUS_DIRECTORY/status
    fi
  else
    echo 1 > $STATUS_DIRECTORY/status
  fi
fi

exit $(cat $STATUS_DIRECTORY/status)
