#!/bin/bash
source "/vagrant/scripts/common.sh"

NODE=21

while getopts s: option
do
	case "${option}"
	in
		s) NODE=${OPTARG};;
	esac
done

function installLocalZookeeper {
	echo "install zookeeper from local file"
	FILE=/vagrant/resources/$ZOOKEEPER_ARCHIVE
	tar -xzf $FILE -C /usr/local
}

function installRemoteZookeeper {
	echo "install zookeeper from remote file"
	curl -o /vagrant/resources/$ZOOKEEPER_ARCHIVE -O -L $ZOOKEEPER_MIRROR_DOWNLOAD
	tar -xzf /vagrant/resources/$ZOOKEEPER_ARCHIVE -C /usr/local
}

function setupZookeeper {
	echo "setup zookeeper"
#	mkdir -p /var/spark/conf/
#	cp -fRp /vagrant/resources/spark/slaves /var/spark/conf/
    cp -f /vagrant/resources/zookeeper/zoo.cfg /usr/local/zookeeper/conf
    # The -p (i.e., parents) option creates the specified intermediate directories for a new directory if they do not already exist
    # mkdir /tmp/zookeeper and put a "myid" file containing node number is a must for zookeeper.
    # should test to see if this file and directory has been set up succsessfully and if node number has been written into this file
    if [ ! -d /tmp/zookeeper ]; then
	    echo "creating zookeeper data dir..."
	    mkdir -p /tmp/zookeeper
	    echo "${NODE}" >> /tmp/zookeeper/myid
	fi
}

function setupEnvVars {
	echo "creating zookeeper environment variables"
#	cp -fRp $SPARK_RES_DIR/spark.sh /etc/profile.d/spark.sh
    cp -f $ZOOKEEPER_RES_DIR/zookeeper.sh /etc/profile.d/zookeeper.sh
}

function installZookeeper {
	if resourceExists $ZOOKEEPER_ARCHIVE; then
		installLocalZookeeper
	else
		installRemoteZookeeper
	fi
	ln -s /usr/local/$ZOOKEEPER_VERSION /usr/local/zookeeper
}

echo "setup zookeeper"

installZookeeper
setupZookeeper
setupEnvVars
