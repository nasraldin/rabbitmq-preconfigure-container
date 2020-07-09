#!/usr/bin/env sh

if [[ debug != "$1" ]]; then
    echo() { :; }
    shift
fi

IMAGE="rabbitmq-server"
TAG="latest"
CONTAINER="rabbitmq-server"

#############################################
#
# Start the rabbitmq-server, but only if it is not already started.
#
# This script was inspired by check_docker_container.sh found here:
#   https://gist.github.com/ekristen/11254304
#
# - Jonathan D'Andries, 12/28/2015
#
#############################################

RUNNING=$(docker inspect --format="{{ .State.Running }}" $CONTAINER 2>/dev/null)

if [ $? -eq 1 ]; then
    echo "Initializing ${CONTAINER}..."
    #The following two are handled by at build-time with rabbit.config
    # If we use them hear, it will overright rabbit.config.
    #  -e RABBITMQ_DEFAULT_USER=admin \
    #  -e RABBITMQ_DEFAULT_PASS=P@$sw0rd \
    docker run -d \
        --hostname $CONTAINER \
        --name $CONTAINER \
        -p 15672:15672 \
        -e RABBITMQ_ERLANG_COOKIE='secret' \
        ${IMAGE}:${TAG}
fi

if [ "$RUNNING" == "false" ]; then
    echo "(Re)starting ${CONTAINER}..."
    docker start $CONTAINER
fi

STARTED=$(docker inspect --format="{{ .State.StartedAt }}" $CONTAINER)
NETWORK=$(docker inspect --format="{{ .NetworkSettings.IPAddress }}" $CONTAINER)
CONTAINER_ID=$(docker inspect --format="{{ .Id }}" $CONTAINER)

echo -e "OK - $CONTAINER is running. \n  IP: $NETWORK\n  CONTAINER ID: $CONTAINER_ID\n  StartedAt: $STARTED"
echo -e "Username: nasr\n Password: nasr\n UI url: http://localhost:15672"