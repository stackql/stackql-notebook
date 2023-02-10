#!/bin/bash

# OPTIONAL: set a token for notebook auth
# export JUPYTER_TOKEN=your_token

# set proivder auth (using config/providerAuth.json)
export STACKQL_PROVIDER_AUTH=$(node /scripts/setAuthObj.js)

# validate stackql
echo "validating stackql install..."
/srv/stackql/stackql --version

# install providers (from config/providers)
while IFS= read -r provider; do
 echo "installing ${provider}"
 /srv/stackql/stackql exec "registry pull ${provider}"
done < /config/providers

# start stackql
/scripts/start-stackql.sh $STACKQL_PROVIDER_AUTH

# start jupyter
if [ -z ${JUPYTER_TOKEN+x} ];
then
    /scripts/start-jupyter.sh
else
    /scripts/start-jupyter.sh $JUPYTER_TOKEN
fi
