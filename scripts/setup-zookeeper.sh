#!/bin/bash
source "/vagrant/scripts/common.sh"

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
