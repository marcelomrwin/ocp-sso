#!/bin/bash

project="$(oc projects | grep ntier)"

if [[ -z ${project} ]]; then
  oc new-project ntier --display-name="SSO N-Tier" --description="SSO secured node.js frontend, JBoss EAP backend and Postgresql datastore with encrypted traffic"
else
  oc project ntier
fi

oc new-app https://github.com/aelkz/ocp-sso \
--context-dir=node \
--name=nodejs-app
 
oc create route edge --service=nodejs-app --cert=server.cert --key=server.key

oc set env --from=configmap/ntier-config dc/nodejs-app
