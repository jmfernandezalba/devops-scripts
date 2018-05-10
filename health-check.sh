#!/bin/bash

CODE=$(curl -s -o /dev/null -w %{http_code} http://${MESOS_AGENT_ENDPOINT%:*}:$PORT0/)

[ $CODE -ge 200 -a $CODE -lt 300 -o $CODE -eq 503 ]

exit $?
