
set -x

echo $MESOS_AGENT_ENDPOINT
echo ${MESOS_AGENT_ENDPOINT%:*}

URL=${MESOS_AGENT_ENDPOINT%:*}

echo $URL

env

CODE=$(curl -s -o /dev/null -w %{http_code} "http://$URL:$PORT0/")

[ $CODE -ge 200 -a $CODE -lt 300 -o $CODE -eq 503 ]

exit $?
