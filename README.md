Note: Due to file limit on CourSys, we delete large resource files such as installation files of hadoop, spark, jdk, maven, zookeeper and kafka and oryx 1 and 2 source files.

============================

vagrant-hadoop-spark-zookeeper-kafka-test-cluster
============================

# 1. Introduction
### Vagrant project to spin up a cluster of 4, 32-bit CentOS6.5 Linux virtual machines with Hadoop v2.6.0 and Spark v1.1.1. 
Ideal for development cluster on a laptop with at least 4GB of memory.

1. node21 : HDFS NameNode + Spark Master + Zookeeper Server + Kafka Broker
2. node22 : YARN ResourceManager + JobHistoryServer + ProxyServer + Zookeeper Server _ Kafka Broker
3. node23 : HDFS DataNode + YARN NodeManager + Spark Slave + Zookeeper Server + Kafka Broker
4. node24 : HDFS DataNode + YARN NodeManager + Spark Slave + Zookeeper Server + Kafka Broker

# 2. Prerequisites and Gotchas to be aware of
1. At least 1GB memory for each VM node. Default script is for 4 nodes, so you need 4GB for the nodes, in addition to the memory for your host machine.
2. Vagrant 1.7 or higher, Virtualbox 4.3.2 or higher
3. Preserve the Unix/OSX end-of-line (EOL) characters while cloning this project; scripts will fail with Windows EOL characters.
4. Project is tested on Ubuntu 32-bit 14.04 LTS host OS; not tested with VMware provider for Vagrant.
5. The Vagrant box is downloaded to the ~/.vagrant.d/boxes directory. On Windows, this is C:/Users/{your-username}/.vagrant.d/boxes.

# 3. Getting Started
1. [Download and install VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. [Download and install Vagrant](http://www.vagrantup.com/downloads.html).
3. Run ```vagrant box add centos65 http://files.brianbirkinbine.com/vagrant-centos-65-i386-minimal.box```
4. Git clone this project, and change directory (cd) into this project (directory).
5. [Download Hadoop 2.6.2 into the /resources directory](http://apache.mirror.gtcomm.net/hadoop/common/hadoop-2.6.2/)
(Here using hadoop-2.6.2.tar.gz)
6. [Download Spark 1.1.1 into the /resources directory](http://d3kbcqa49mib13.cloudfront.net/spark-1.1.1-bin-hadoop2.4.tgz)
7. [Download Java 1.8 into the /resources directory](http://download.oracle.com/otn-pub/java/jdk/8u25-b17/jdk-8u25-linux-i586.tar.gz)
(Here using jdk-8u65-linux-i586.tar.gz)
8. [Download Maven 3.2.1 into the /resources directory] (http://archive.apache.org/dist/maven/maven-3/3.2.1/binaries/)
(Here using apache-maven-3.2.1-bin.tar.gz)
9. [Download Zookeeper 3.4.6 stable into the /resources directory](http://apache.mirror.gtcomm.net/zookeeper/zookeeper-3.4.6/)
   (Here using zookeeper-3.4.6.tar.gz)
10. [Download Kafka 2.9.1-0.8.2.0 into the /resources directory](http://kafka.apache.org/downloads.html)
   (Here using kafka_2.9.1-0.8.2.0.tgz)
11. [Download Oryx 1](https://github.com/cloudera/oryx)
   (Put it under /resources/oryx directory)
12. [Download Oryx 2 if it does not exist under /resources/oryx2 directory](https://github.com/OryxProject/oryx/releases/tag/oryx-2.1.0)
   (Here is using oryx 2.1.0 and download those five scripts of bash and jar files)
13. Run ```vagrant up``` to create the VM.
14. Run ```vagrant ssh``` to get into your VM.
15. Run ```vagrant destroy``` when you want to destroy and get rid of the VM.
16. test cluster by following steps in 5 Post Provisioning
17. Run Oryx 1 and Oryx 2 commands by following 7 Deploy and Run Oryx Project


# 4. Modifying scripts for adapting to your environment
You need to modify the scripts to adapt the VM setup to your environment.  

1. [List of available Vagrant boxes](http://www.vagrantbox.es)

2. ./Vagrantfile  
To add/remove slaves, change the number of nodes:  
```numNodes = 4```  
To modify VM memory change the following line:  
```v.customize ["modifyvm", :id, "--memory", "1024"]```  
3. /scripts/common.sh  
To use a different version of Java, change the following lines of codes depending on the version you downloaded to /resources directory. 
```
JAVA_ARCHIVE=jdk-8u25-linux-i586.tar.gz
```
To use a different version of Hadoop you've already downloaded to /resources directory, change the following line:  
```
HADOOP_VERSION=hadoop-2.6.2
```
To use a different version of Hadoop to be downloaded, change the remote URL in the following line:  
```
HADOOP_MIRROR_DOWNLOAD=http://apache.crihan.fr/dist/hadoop/common/stable/hadoop-2.6.2.tar.gz
```  
To use a different version of other tools, follow similar steps here to change corresponding lines of codes 

4. /scripts/setup-java.sh  
To install from Java downloaded locally in /resources directory, if different from default version (1.8.0_25), change the version in the following line:
```ln -s /usr/local/jdk1.8.0_25 /usr/local/java```  
To modify version of Java to be installed from remote location on the web, change the version in the following line:  
```yum install -y jdk-8u25-linux-i586```  

5. /scripts/setup-centos-ssh.sh  
To modify the version of sshpass to use, change the following lines within the function installSSHPass():  
```wget http://pkgs.repoforge.org/sshpass/sshpass-1.05-1.el6.rf.i686.rpm```  
```rpm -ivh sshpass-1.05-1.el6.rf.i686.rpm```  

6. /scripts/setup-spark.sh  
To modify the version of Spark to be used, if different from default version (built for Hadoop2.6), change the version suffix in the following line:  
```ln -s /usr/local/$SPARK_VERSION-bin-hadoop2.6 /usr/local/spark```

7. To add more tools
Create [tool].sh file (see into hadoop.sh for clues if need to cp configurations) under /scripts and add this .sh script to /scripts/common.sh and VagrantFile. Add tool installation file to /resources and if it has some configurations or needs to export and add path values, create a /resources/[tool-name] folder and put configurations and path values files into this folder. 

8. To change node index
Change $START and -s value or lines of codes containing (seq 1/$INIT_START $NUM_NODES) and check ip addresses associated with it.


# 5. Post Provisioning
After you have provisioned the cluster, you need to run some commands to initialize your Hadoop cluster. SSH into node21 using  
```
vagrant ssh node-21
```
On node-21, the command below requires root permissions. Change to root access:
```
$[vagrant@node-21~] sudo su
```
Issue the following command:
```
$[root@node-21~] $HADOOP_PREFIX/bin/hdfs namenode -format
```

## Start Hadoop Daemons (HDFS + YARN)
Commands below sometimes require password and root access. They are all the same (password is "vagrant", without double quotes).
SSH into node21 
```
vagrant ssh node-21
```
Use root access
```
$[vagrant@node-21~] sudo su
```
And launch following commands to start HDFS.

```
1. $[root@node-21~] $HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode
```
```
2. $[root@node-21~] $HADOOP_PREFIX/sbin/hadoop-daemons.sh --config $HADOOP_CONF_DIR --script hdfs start datanode
```

Start a new terminal window and SSH into node22 
```
vagrant ssh node-22
```
And implement following commands to start YARN (password is vagrant).

```
1. $[root@node-22~] $HADOOP_YARN_HOME/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start resourcemanager
```
```
2. $[root@node-22~] $HADOOP_YARN_HOME/sbin/yarn-daemons.sh --config $HADOOP_CONF_DIR start nodemanager
```

Now, if stays on previous status, press "enter" to get $[root@node-22~] back. 
```
vagrant ssh node-22
```
And run following commands

```
3. $[root@node-22~] $HADOOP_YARN_HOME/sbin/yarn-daemon.sh start proxyserver --config $HADOOP_CONF_DIR
```
```
4. $[root@node-22~] $HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver --config $HADOOP_CONF_DIR
```

### Test YARN
Run the following command to make sure you can run a MapReduce job. (yarn cannot be run on root access, so change to vagrant access)
```
$[root@node-21~] exit
```
```
$[vagrant@node-21~] yarn jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.2.jar pi 2 100
```

## Start Spark

On node21 to run the following command:

```
$[root@node-21~] $SPARK_HOME/sbin/start-all.sh
```

### Test Spark on YARN
Start a new termial if necessary. You can test if Spark can run on YARN by issuing the following command. Try NOT to run this command on the slave nodes.
```
$[vagrant@node-21~] $SPARK_HOME/bin/spark-submit --class org.apache.spark.examples.SparkPi \
--master yarn-cluster \
--num-executors 10 \
--executor-cores 2 \
/usr/local/spark/lib/spark-examples*.jar \
100
```
If it says JAVA_HOME not set, you can fix this by following steps below:
```
$[vagrang@node-21~] sudo vi /usr/local/spark/bin/spark-class
```
Then revise codes where to identify java directory to these:
```
else
   echo "JAVA_HOME is not set"
   RUNNER="/usr/local/java/bin/java"
   echo "Set RUNNER to default java directory"
   # exit 1
```
Next, log out node 21 and ssh to it again. Repeate spark command. (This problem has been fixed, but put the solution here just in case)

If it has running errors, it is because the default Java Running Environment has 2G memory, which is larger than our node memory. Therefore create "spark-defaults.conf" under /usr/local/spark/conf/ directory and write this line of code into it (This error has been fixed since we have a spark-defaults.conf under /resources/spark folder):
```
spark.executor.memory=256m
``` 

### Test Spark using Shell
Start the Spark shell using the following command. Try NOT to run this command on the slave nodes.

```
$[vagrant@node-21~] $SPARK_HOME/bin/spark-shell --master spark://node21:7077
```

Then go here https://spark.apache.org/docs/latest/quick-start.html to start the tutorial. Most likely, you will have to load data into HDFS to make the tutorial work (Spark cannot read data on the local file system).

### Test Kafka using shell
first vagrant ssh to a node and check if /tmp/zookeeper exists on this node (Note: /tmp/zookeeper is the dataDir propery specified in zookeeper.properties under /usr/local/kafka/config and zoo.cfg under /usr/local/zookeeper/conf. You can define the directory by yourself, but should change them in zookeeper.properties and in zoo.cfg). This folder must exist before running following commands.

Launch this command to start zookeeper (use this command on three nodes to start zookeeper service. You can ignore errors at first because they are waiting for communications. After zookeeper starts on all three nodes, you will see one node become the leader and there is no error.):
(you need in root access, so first sudo su)
```
$[vagrant@node] sudo su
```
```
$[root@node] /usr/local/kafka/bin/zookeeper-server-start.sh /usr/local/kafka/config/zookeeper.properties 
```

Next, launch this command to start kafka broker (assume you are on node 21 now)
(Note: by default, kafka thinks Java Runtime Environment is at least 1G, so in our case, each virtual node has at most 1G memory, so you need to change KAFKA_HEAP_OPTS in kafka-server-start.sh)
```
$[root@node] vi /usr/local/kafka/bin/kafka-server-start.sh
```
change line of code relating to KAFKA_HEAP_OPTS in kafka-server-start.sh to (press a to insert):
```
export KAFKA_HEAP_OPTS="-Xmx256M -Xms128M"
```
save exit by pressing :wq. Then it is safe to run the following step
```
$[root@node-21~] /usr/local/kafka/bin/kafka-server-start.sh /usr/local/kafka/config/server21.properties &
```
If it gives you java not found, you can fix this by steps below:
```
$[root@node-21~] vi /usr/local/kafka/bin/kafka-run-class.sh
```
Change codes from line 101 to 106 in this file related to JAVA_HOME to:
```
# Which java to use
if [ -z "$JAVA_HOME" ]; then
  JAVA="/usr/local/java/bin/java"
else
  JAVA="/usr/local/java/bin/java"
fi
```
Save exit, might need to log out and log in again to make revised .sh script work. (This problem has been fixed, but leave the solution here just in case)

## Other commands that might need
in our cluster, user “vagrant” has no root access, so if it appears permission denied, it is able to give all access to “vagrant” by running command below:
```
$[root access] chmod -R 777 [the-directory-to-be-assigned-all-access]
```

# 6. Web UI
You can check the following URLs to monitor the Hadoop daemons.

1. [NameNode] (http://10.211.55.121:50070/dfshealth.html)
2. [ResourceManager] (http://10.211.55.122:8088/cluster)
3. [JobHistory] (http://10.211.55.122:19888/jobhistory)
4. [Spark] (http://10.211.55.121:8080)
5. [Oryx](10.211.55.121:80)

# 7. Deploy and Run Oryx Project

First give user “vagrant” all access to oryx and oryx2 folder by typing this command:
```
$[vagrant@node[node index]~] chmod -R 777 /home/vagrant/oryx/[or /home/vagrant/oryx2/]
```
If it still requires permission to apache tools, use this command on apache tool installation directory:
```
$[root@node[node index]~] chmod -R 777 /usr/local/
```
Start Kafka and zookeeper service, 
Oryx 1:
on node 21
```
cd /home/vagrant/oryx
```
When you under oryx root folder (the root folder must be exactly named as “oryx”, otherwise, maven build will fail due to not able to find plugins), issue the following command to build Oryx 1 project. (Oryx 1 needs to be maven built before running for the first time)
```
mvn -DskipTests=true [clean] install -Drat.skip=true
```
The "-Drat.skip" option is put here because it will ignore plugins without licenses, otherwise it will interrupt maven build process. "-DskipTests=true“ is to skip test cases when building oryx 1, otherwise it will take much longer time to complete the building process .

After maven build successfully which will take 5 to 10 minutes to be done, you will see target folder under /computation and /serving folder. And inside them, there are oryx-computation-1.1.1.SNAPSHOT.jar and oryx-serving-1.1.1.SNAPSHOT.jar. 

Now by following running steps shown on [oryx 1 website](https://github.com/cloudera/oryx), you will see prediction results.

Oryx 2:
Check if there are five scripts (compute-classpath.sh, oryx-bach-2.1.0.jar, oryx-run.sh, oryx-serving-2.1.0.jar, oryx-speed-2.1.0.jar) under /home/vagrant/oryx2 directory (this is the default directory we set in VagrantFile). 

Then start zookeeper and kafka service on node 21, node 22 and node 23 (or node 24). Make sure at least one Kafka broker is running and Zookeeper is running on at least three nodes.You might see some errors thrown out at first because when zookeeper and kafka service are started, they will take some time to communicate. Wait for a minute, then you will see errors disappear and they find other zookeeper nodes in this cluster.

Open a new terminal to run Oryx 2 project and enter into “oryx2” folder.

Add this line of code into “compute-classpath.sh”:
```
SPARK_STREAMING_JARS="${SPARK_EXAMPLES_JAR}"
SPARK_STREAMING_JARS="/usr/local/spark/lib/spark-examples-1.5.1-hadoop2.6.0.jar"    

```

Create a oryx.conf and follow examples shown on [Oryx 2 github website](https://github.com/OryxProject/oryx/blob/master/app/conf/als-example.conf) and put this oryx.conf under /usr/local/oryx2 directory, same where other five scripts stored. Create hdfs directory like (create each sub-directory one after one):
```
hadoop fs -mkdir /user/example
```
```
hadoop fs -mkdir /user/example/Oryx
```

Change values of kafka-brokers and zk-servers in this file to: (Assume you are running on node-21)
```
kafka-brokers = "10.211.55.121:9092"
zk-servers = "10.211.55.121:2181"
hdfs-base = "hdfs:///user/example/Oryx"
```

Change values of batch setting to:
```
batch {
    streaming {
      generation-interval-sec = 300
      num-executors = 2
      executor-cores = 4
      executor-memory = “1g”
    }
    update-class = "com.cloudera.oryx.app.batch.mllib.als.ALSUpdate"
    storage {
      data-dir =  ${hdfs-base}"/data/"
      model-dir = ${hdfs-base}"/model/"
    }
    ui {
      port = 4040
    }
  }
```
Create a kafka topic by running :
```
cd /usr/local/oryx2
```
```
/home/vagrant/oryx2/oryx-run.sh kafka-setup
```
You will see same print out information in the console as it is shown on [Oryx 2 Doc Admin](http://oryx.io/docs/admin.html). Type “y” for questions asked during topic creation

Next, to start batch-layer, speed-layer and serving-layer by following steps on [Oryx 2 End Users](http://oryx.io/docs/endusers.html#Running). For example, if you choose node 21 to run batch-layer, then it will be:
```
cd /home/vagrant/oryx2
```
```
/home/vagrant/oryx2/oryx-run.sh batch
```
Because of our computer memory limit, we cannot set memory of each virtual node more than 1G and it might conflict with Oryx 2’s minimum running requirements of at least 4g of memory. 

# 8. References
This project was put together with great pointers from all around the internet. All references made inside the files themselves.
Primaily this project is forked from [Jee Vang's vagrant project](https://github.com/vangj/vagrant-hadoop-2.4.1-spark-1.0.1)

# 9. Copyright Stuff
Redesigned and revised based on Maloy Manna's project framework Copyright 2014 Maloy Manna

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

(http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

