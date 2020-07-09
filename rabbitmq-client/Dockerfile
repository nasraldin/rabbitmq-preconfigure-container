FROM rabbitmq:latest

RUN mkdir -p /etc/bash_completion.d/ \
    && apt-get update && apt-get install -y --no-install-recommends \
    && apt install python3 -y \
    && rm -rf /var/lib/apt/lists/*

# The following file was downloaded from the running instance
# of rabbitmq:management using the url:
# http://{server}:{managementport}/cli/rabbitmqadmin 
# e.g., http://192.168.0.13:15672/cli/rabbitmqadmin
COPY rabbitmqadmin /usr/local/bin/rabbitmqadmin

ENV HOME /root

# Calling "; sync" in the following command because we get the following
# error without it:
#     /bin/sh: 1: rabbitmqadmin: Text file busy
# More info here: https://github.com/docker/docker/issues/9547

RUN chmod 755 /usr/local/bin/rabbitmqadmin; sync
RUN rabbitmqadmin --bash-completion > /etc/bash_completion.d/rabbitmqadmin
RUN echo "source /etc/bash_completion.d/rabbitmqadmin" >> ~/.bashrc

CMD [ "/bin/bash" ]
