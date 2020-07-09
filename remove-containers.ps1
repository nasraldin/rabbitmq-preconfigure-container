docker rm $(docker stop rabbitmq-server)
docker rmi rabbitmq-server
docker rmi rabbitmq-client
