#!/usr/bin/env bash

## Set default variables
IMAGE=comskip-build-static
CONTAINER="$IMAGE"

check_exitcode() { ## Args: <log message>
    if [ $? -ne 0 ]; then
        echo "$1" >&2
        exit 1
    fi
}

## Build image if not already built
if [ -z "$(docker images -q $IMAGE 2>/dev/null)" ]; then
    docker build -t "$IMAGE" .
    check_exitcode "Error building docker image '$IMAGE'"
fi

## Run container
docker run -dit --rm \
    --name "$CONTAINER" \
    --volume ./bin:/build/bin \
    --env FFMPEG_VERSION=4.3.6 \
    --env COMSKIP_TAR_DL=https://github.com/erikkaashoek/Comskip/archive/master.tar.gz \
    "$IMAGE"
check_exitcode "Error starting container '$CONTAINER'"

## Follow container logs
#docker logs -f comskip-build-static

## Strip binary to decrease its size
#strip bin/comskip
