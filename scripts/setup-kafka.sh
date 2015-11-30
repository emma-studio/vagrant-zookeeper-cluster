#!/bin/bash
source "/vagrant/scripts/common.sh"

function installLocalKafka {
	echo "install kafka from local file"
	FILE=/vagrant/resources/$KAFKA_ARCHIVE
	tar -xzf $FILE -C /usr/local
}

function installRemoteKafka {
	echo "install kafka from remote file"
	curl -o /vagrant/resources/$KAFKA_ARCHIVE -O -L $KAFKA_MIRROR_DOWNLOAD
	tar -xzf /vagrant/resources/$KAFKA_ARCHIVE -C /usr/local/
}

function setupKafka {
	echo "copying over kafka configuration files"
    # mkdir $HADOOP_CONF
	cp -f $KAFKA_RES_DIR/* $KAFKA_CONF
}

function setupEnvVars {
	echo "creating kafka environment variables"
	cp -f $KAFKA_RES_DIR/kafka.sh /etc/profile.d/kafka.sh
}

function installKafka {
	if resourceExists $KAFKA_ARCHIVE; then
		installLocalKafka
	else
		installRemoteKafka
	fi
	ln -s /usr/local/$KAFKA_VERSION /usr/local/kafka
}


echo "setup kafka"
installKafka
setupKafka
setupEnvVars