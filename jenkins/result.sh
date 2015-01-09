#!/bin/bash

JENKINS_JOB=test
REPO=test
JENKINS_URL=jenkins
USERNAME=jenkins
PASSWORD=jenkins
OWNER=jenkins
BUCKET_API_V1_URL="https://bitbucket.org/api/1.0/repositories/"
BUCKET_API_V2_URL="https://bitbucket.org/api/2.0/repositories/"

if [[ -z $JENKINS_URL ]]
then
    echo 'No CI server is set.'
    exit 0
fi

JOB=`curl --silent http://$JENKINS_URL/job/$JENKINS_JOB/lastBuild/api/json?pretty=true |\
     grep result |\
     awk '{print $3}' |\
     sed 's/,//g'`

URL=`curl --silent http://$JENKINS_URL/job/$JENKINS_JOB/lastBuild/api/json?pretty=true |\
     grep '"url"' |\
     awk '{print $3}' |\
     sed 's/,//g' |\
     tr -d '"'`

REQUEST_ID=`curl --silent -u $USERNAME:$PASSWORD $BUCKET_API_V2_URL$OWNER/$REPO/pullrequests |\
            python -mjson.tool |\
            grep id |\
            awk '{print $2}' |\
            sed 's/,//g'`

function success()
{
  curl --silent \
    -H "Content-Type: application/json" \
    -u $USERNAME:$PASSWORD \
    -X POST -d '{"content": "'**:star:Bravo''" "''Micko,''" "''evo''" "''ti''" "'':apple:**''" "''$URL'"}' \
    "$BUCKET_API_V1_URL$OWNER/$REPO/pullrequests/${REQUEST_ID}/comments" 1>/dev/null
}

function unstable()
{
  curl --silent \
    -H "Content-Type: application/json" \
    -u $USERNAME:$PASSWORD \
    -X POST -d '{"content":  "'**Micko,''" "''dobro''" "''je''" "''ali''" "''moze''" "''bolje.**''" "''$URL'"}' \
    "$BUCKET_API_V1_URL$OWNER/$REPO/pullrequests/${REQUEST_ID}/comments" 1>/dev/null
}

function fail()
{
  curl --silent \
    -H "Content-Type: application/json" \
    -u $USERNAME:$PASSWORD \
    -X POST -d '{"content":  "'**:bow:''" "''Micko''" "''ne''" "''valja''" "''nesto.**''" "''$URL'"}' \
    "$BUCKET_API_V1_URL$OWNER/$REPO/pullrequests/${REQUEST_ID}/comments" 1>/dev/null
}

if [[ "$JOB" == '"SUCCESS"' ]]
then
  success
elif [[ "$JOB" == '"UNSTABLE"' ]]
then
  unstable
else
  fail
fi
