#!/bin/bash
source "/vagrant/scripts/common.sh"

function installLocalMaven {
    echo "installing maven 3.2.1"
    FILE=/vagrant/resources/$MAVEN_ARCHIVE
    tar -xzf $FILE -C /usr/local
}

function installRemoteMaven {
    echo "install open maven 3.2.1"
    yum install -y apache-maven-3.2.1
}

function setupMaven {
    echo "setting up maven"
    if resourceExists $MAVEN_ARCHIVE; then
        ln -s /usr/local/apache-maven-3.2.1 /usr/local/maven
    else
        echo "Cannot Find MAVEN_ARCHIVE"
    fi
}

function setupEnvVars {
    echo "creating maven environment variables"
    echo export M2_HOME=/usr/local/maven >> /etc/profile.d/maven.sh
    echo export PATH=\${M2_HOME}/bin:\${PATH} >> /etc/profile.d/maven.sh
}

function installMaven {
    if resourceExists $MAVEN_ARCHIVE; then
        installLocalMaven
    else
        installRemoteMaven
    fi
}

echo "setup maven"
installMaven
setupMaven
setupEnvVars
