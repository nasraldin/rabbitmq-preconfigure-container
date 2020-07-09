docker run -it \
    --rm \
    --name rabbitmq-client \
    --link rabbitmq-server \
    -e RABBITMQ_ERLANG_COOKIE='secret' \
    -e RABBITMQ_NODENAME=rabbit@rabbitmq-server \
    rabbitmq-client
