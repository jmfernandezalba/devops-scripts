
set -x

export APP_DIRECTORY=/tmp$MARATHON_APP_ID
export STATUS_DIRECTORY=$APP_DIRECTORY/$MESOS_TASK_ID

mkdir -p $STATUS_DIRECTORY

echo $HOST

CODE=$(curl -s -o /dev/null -w %{http_code} http://${MESOS_AGENT_ENDPOINT%:*}:$PORT0${HEALTH_PATH:-/health})

if [ $CODE -ge 200 -a $CODE -lt 300 ]
then
  echo 0 > $STATUS_DIRECTORY/status
else
  if [ $CODE -eq 503 ]
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
