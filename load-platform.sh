#!/bin/bash -e

MAX_RETRY=30

# Wait for Jenkins to be up and running
# -------------------------------------------------------------------------------------
COUNT=1
until [[ $(curl -I -s ${ADOP_CLI_USER}:${ADOP_CLI_PASSWORD}@${TARGET_HOST}/jenkins/|head -n 1|cut -d$' ' -f2) == 200 ]] || [[ $MAX_RETRY -lt $COUNT ]]
do
  echo "Jenkins unavailable, sleeping for 5s"
  sleep 5
  ((COUNT ++))
done
echo "Jenkins instance is up and running man!"

# Load Gitlab Platform - Create Generate Workspace job
# -------------------------------------------------------------------------------------
JOB_URL=${TARGET_HOST}/jenkins/job/Load_Platform
curl -s -X POST "${INITIAL_ADMIN_USER}:${ADOP_CLI_PASSWORD}@${JOB_URL}/buildWithParameters?delay=0sec&GIT_URL=https://github.com/Accenture/adop-platform-management.git&GENERATE_EXAMPLE_WORKSPACE=true"
