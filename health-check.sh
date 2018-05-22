
set -x

CODE=$(curl -s -o /dev/null -w %{http_code} http://${MESOS_AGENT_ENDPOINT%:*}:$PORT0/)

if [ $CODE -ge 200 -a $CODE -lt 300 ]
then
  echo 0 > $MESOS_DIRECTORY/status
else
  if [ $CODE -eq 503 ]
  then
    if [ ! -f $MESOS_DIRECTORY/status ]
    then
      echo 1 > $MESOS_DIRECTORY/status
    fi
  else
    echo 1 > $MESOS_DIRECTORY/status
  fi
fi

exit $(cat $MESOS_DIRECTORY/status)
