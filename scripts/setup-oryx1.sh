#!/bin/bash
source "/vagrant/scripts/common.sh"

# function installLocalOryx {
# 	echo "install oryx from local file"
# 	FILE=/vagrant/resources/$SPARK_ARCHIVE
# 	# tar -xzf $FILE -C /usr/local
# }

function setupOryx1 {
	echo "setup oryx 1"
#	mkdir -p /var/spark/conf/
#	cp -fRp /vagrant/resources/spark/slaves /var/spark/conf/
    mkdir -p $ORYX1_CONF_DIR
    cp -r $ORYX1_RES_DIR/* $ORYX1_CONF_DIR
}

# function installSpark {
# 	if resourceExists $SPARK_ARCHIVE; then
# 		installLocalSpark
# 	else
# 		installRemoteSpark
# 	fi
# 	ln -s /usr/local/$SPARK_VERSION-bin-hadoop2.6 /usr/local/spark
# }

echo "setup Oryx 1"

# installSpark
setupOryx1
# setupEnvVars
