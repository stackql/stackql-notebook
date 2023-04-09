#!/bin/bash

if [ "$1" = "srv" ]; then
    export SERVER_MODE=true
else
    export SERVER_MODE=false
fi

# OPTIONAL: set a token for notebook auth
# export JUPYTER_TOKEN=your_token

# set proivder auth (using config/providerAuth.json)
# export STACKQL_PROVIDER_AUTH=$(node /scripts/setAuthObj.js)

# validate stackql
echo "validating stackql install..."
/srv/stackql/stackql --version

# install providers (from config/providers)
while IFS= read -r provider; do
 echo "installing ${provider}"
 /srv/stackql/stackql exec "registry pull ${provider}"
done < /config/providers

# start stackql if SERVER_MODE is true
if [ "$SERVER_MODE" = true ]; then
    echo "starting stackql server..."
    /scripts/start-stackql.sh
fi

# start jupyter
if [ -z ${JUPYTER_TOKEN+x} ];
then
    /scripts/start-jupyter.sh
else
    /scripts/start-jupyter.sh $JUPYTER_TOKEN
fi
