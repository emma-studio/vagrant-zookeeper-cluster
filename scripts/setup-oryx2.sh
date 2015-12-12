#!/bin/bash
source "/vagrant/scripts/common.sh"

# function installLocalOryx {
# 	echo "install oryx from local file"
# 	FILE=/vagrant/resources/$SPARK_ARCHIVE
# 	# tar -xzf $FILE -C /usr/local
# }

function setupOryx2 {
	echo "setup oryx 2"
#	mkdir -p /var/spark/conf/
#	cp -fRp /vagrant/resources/spark/slaves /var/spark/conf/
    mkdir -p $ORYX2_CONF_DIR
    cp -r $ORYX2_RES_DIR/* $ORYX2_CONF_DIR
}

# function installSpark {
# 	if resourceExists $SPARK_ARCHIVE; then
# 		installLocalSpark
# 	else
# 		installRemoteSpark
# 	fi
# 	ln -s /usr/local/$SPARK_VERSION-bin-hadoop2.6 /usr/local/spark
# }

echo "setup Oryx 2"

# installSpark
setupOryx2
# setupEnvVars
