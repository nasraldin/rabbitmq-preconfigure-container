# Pre-configure RabbitMQ Custom Container

Creates a custom docker container for RabbitMQ with a pre-configure users, vhost (example-vhost), exchange (example-exchange), and queue (example-queue) with appropriate bindings therein.

You can use this project to create your own pre-configured RabbitMQ image and container that you setup either by

1. directly modifying the included definitions.json configuration
2. (**recommended**) using the RabbitMQ management interface to create the vhosts, exchanges, queues, and bindings that you want, and then exporting the resulting configuration to overright the included custom_definitions.json file.

The following instructions explain how to run the RabbitMQ server container, modify the included custom configuration using your web browser in the RabbitMQ management interface, and then export the resulting configuration to include your changes in a new custom RabbitMQ server image and container.


## Getting Started

We have two docker containers in this project:

1. **rabbitmq-server** = This is the server we want, pre-configured with vhost, exchange, and queue.
2. **rabbitmq-client** = This is another instance of rabbitmq "linked" to the above server container so that we can run the rabbit command line interfaces (cli's) against the server.

#### Build and run the RabbitMQ server container with docker-compose:

#### Step-1:

Start in the root directory of this project, then

```bash
docker-compose up --build -d
```

command output
```bash
Starting rabbitmq-server ... done
Starting rabbitmq-client ... done
```

You should see a running container in Docker that looks something like the following:


```bash
docker ps
```

 <img src="https://github.com/nasraldin/rabbitmq-preconfigure-container/blob/master/img/rabbitmq-dev-ps.png" />

if you running portainer you can see the new stack named as **rabbitmq-dev**
 portainer default url on [http://localhost:9000](http://localhost:9000/#/stacks/rabbitmq-dev?type=2&external=true)
 
 <img src="https://github.com/nasraldin/rabbitmq-preconfigure-container/blob/master/img/rabbitmq-dev-stack.png" />

** to login to client container bash

```bash
docker exec -it rabbitmq-client bash
```

#### Step-2:

Use the management interface with your web browser to setup RabbitMQ for your environment.

If the server container is running, you should be able to reach the RabbitMQ management interface in your web browser on localhost as follows: [http://localhost:15672/]().

We have 2 users configured in start server you can use anyone of them, it has administrator privilege

* Username/Password: `nasr`

* Username: `admin`
* Password: `P@$sw0rd`

> Note, however, that if you are using **docker-machine** instead of running docker natively, you will need to know the ip address of the running machine vm (instead of localhost). Most people run a docker-machine named 'default', and can therefore get the IP as follows:
>  ```docker-machine ip default```
> On my computer, this resolved to 192.168.0.4, which means I would access the RabbitMQ management interface with the following address: [http://192.168.0.4:15672/]()


#### Build and run the RabbitMQ server container with .sh files in project (build_server.sh - run_server.sh):

#### Step-1:

Start in the root directory of this project, then

Build and run the RabbitMQ server container:

```bash
./build_server.sh
./run_server.sh
```
This should bring you to a bash command prompt for the client container.

Build and run the RabbitMQ client container:

```bash
cd ./rabbitmq-client

./build_client.sh
./run_client.sh
```

This should bring you to a bash command prompt for the client container.

In the bash prompt for the client container from the prior step, export the current configuration of the rabbitmq-server:

```bash
rabbitmqadmin --host rabbitmq-server --username nasr --password nasr export custom_definitions.json
```

View the contents of the resulting file:

```bash
cat custom_definitions.json
```

The results are not formatted nicely (all on one line), and they look something like this:

 <img src="https://github.com/nasraldin/rabbitmq-preconfigure-container/blob/master/img/rabbitmq-dev-config.png" />

You can use the above output to overright the included file in server/custom_definitions.json. 
> You might also want to use a nice json editor like Visual Studio Code to format the output before pasting into server definitions.json

Exit the client container:

```bash
exit
```

#### Remove RabbitMQ containers:

Back in the root of this project, if you with to remove the RabbitMQ containers:

```bash
./remove-containers.sh
```

You can rebuild and re-run the server container (see step #1 above) and then connect to it in with your web browser (see step #2 above) to verify that your custom configurations have worked.

#### Make any edits you like:

Make any edits you like to ```run_server.sh``` and ```Dockerfile``` to reflect your organization. You might also want to publish your resulting server image on DockerHub and/or in a private Docker repository.

## Server usage

```bash
./build_server.sh
./run_server.sh [debug]
```
The management console should be running on port 15672. The base URL differs depending on your environment:

* If you are running docker natively, you can access the management console from here: [http://localhost:15672/](http://localhost:15672/)
* If you are running in docker-machine, and you are using "default" as the machine name, you can use the following command to show the URL for the management console:

   ```echo "http://$(docker-machine ip default):15672/"```

## Client usage

```bash
./build_client.sh
./run_client.sh
```

Export the current configuration of the rabbitmq-server:

```bash
rabbitmqadmin --host rabbitmq-server --username nasr --password nasr export custom_definitions.json
```

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request.

