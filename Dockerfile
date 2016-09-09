FROM ubuntu:16.04

# Echo configure to download mongodb packages via apt
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list

# refresh apt repos
RUN apt-get -y update

# install useful packages: editors, python3, gradle and zookeeper
RUN apt-get install -y emacs vim python3 python3-pip gradle zookeeper
# install some other misc but useful packages
RUN apt-get install -y curl libreadline-dev bc less git

# install useful python packages
RUN echo pip3 install pytz flask requests slackclient

# install mongodb
RUN apt-get install -y mongodb-org

# next batch of things need to be downloaded as tgz files. Make /extra and
# put them there, if not there already
RUN mkdir /extra 
RUN cd /extra && if [ ! -e kafka_2.11-0.10.0.1.tgz ]; then curl -O http://apache.cs.utah.edu/kafka/0.10.0.1/kafka_2.11-0.10.0.1.tgz && tar -xvzf kafka_2.11-0.10.0.1.tgz ; fi
RUN cd /extra && if [ ! -e spark-2.0.0-bin-hadoop2.7.tgz ]; then curl -O http://d3kbcqa49mib13.cloudfront.net/spark-2.0.0-bin-hadoop2.7.tgz && tar -xvzf spark-2.0.0-bin-hadoop2.7.tgz ; fi
RUN cd /extra && git clone https://github.com/rareitmeyer/slackbot

# RUN echo "also, still need the step to install the MongoDB Spark package from instructions at https://databricks.com/blog/2015/03/20/using-mongodb-with-spark.html"

RUN echo "to start Kafka, run the following from the quickstart at http://kafka.apache.org/documentation.html#quickstart:"
RUN echo "    /etc/kafka*/bin/zookeeper-server-start.sh config/zookeeper.properties "
RUN echo "    /etc/kafka*/bin/kafka-server-start.sh config/server.properties"

CMD /bin/bash

