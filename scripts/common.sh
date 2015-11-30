#!/bin/bash

#java
JAVA_ARCHIVE=jdk-8u65-linux-i586.gz
#maven
MAVEN_ARCHIVE=apache-maven-3.2.1-bin.tar.gz
#hadoop
HADOOP_PREFIX=/usr/local/hadoop
HADOOP_CONF=$HADOOP_PREFIX/etc/hadoop
#HADOOP_PREFIX=/var/hadoop/
#HADOOP_CONF=$HADOOP_PREFIX/conf/
HADOOP_VERSION=hadoop-2.6.2
HADOOP_ARCHIVE=$HADOOP_VERSION.tar.gz
HADOOP_MIRROR_DOWNLOAD=../resources/hadoop-2.6.2.tar.gz
HADOOP_RES_DIR=/vagrant/resources/hadoop
#spark
SPARK_VERSION=spark-1.5.1
SPARK_ARCHIVE=$SPARK_VERSION-bin-hadoop2.6.tgz
SPARK_MIRROR_DOWNLOAD=../resources/spark-1.5.1-bin-hadoop2.6.tgz
SPARK_RES_DIR=/vagrant/resources/spark
SPARK_CONF_DIR=/usr/local/spark/conf
#zookeeper
ZOOKEEPER_VERSION=zookeeper-3.4.6
ZOOKEEPER_ARCHIVE=$ZOOKEEPER_VERSION.tar.gz
ZOOKEEPER_MIRROR_DOWNLOAD=../resources/zookeeper-3.4.6.tar.gz
ZOOKEEPER_RES_DIR=/vagrant/resources/zookeeper
ZOOKEEPER_CONF_DIR=/usr/local/zookeeper/conf
#kafka
KAFKA_VERSION=kafka_2.9.1-0.8.2.2
KAFKA_ARCHIVE=$KAFKA_VERSION.tgz
KAFKA_MIRROR_DOWNLOAD=../resources/kafka_2.9.1-0.8.2.2.tgz
KAFKA_RES_DIR=/vagrant/resources/kafka
#KAFKA_CONF_DIR=/usr/local/kafka/config
KAFKA_CONF=/usr/local/kafka/config
#ssh
SSH_RES_DIR=/vagrant/resources/ssh
RES_SSH_COPYID_ORIGINAL=$SSH_RES_DIR/ssh-copy-id.original
RES_SSH_COPYID_MODIFIED=$SSH_RES_DIR/ssh-copy-id.modified
RES_SSH_CONFIG=$SSH_RES_DIR/config

function resourceExists {
	FILE=/vagrant/resources/$1
	if [ -e $FILE ]
	then
		return 0
	else
		return 1
	fi
}

function fileExists {
	FILE=$1
	if [ -e $FILE ]
	then
		return 0
	else
		return 1
	fi
}

#echo "common loaded"
