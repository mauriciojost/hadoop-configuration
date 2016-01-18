# README

This project aims to help you get started with your own yarn cluster. 

## Set environment

Add to your `~/.localrc` the following:

```
export HADOOP_HOME=$HOME/opt/hadoop
HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop/
export PATH=$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$PATH

```

## Set slaves

Modify the file `etc/hadoop/slaves` including all slave hosts' IP addresses.

## Start hadoop

### Format HDFS namenode
Before you can start using HDFS you need to format the namenode, doing.

```
hadoop namenode -format
```

### Launch YARN

Once this is done you can start by launching YARN:

```
start-yarn.sh
```

It should give as output something like: 

```
mjost@tuca:~/opt/hadoop$ ./sbin/start-yarn.sh 
starting yarn daemons
starting resourcemanager, logging to /home/mjost/opt/zips/hadoop-2.7.1/logs/yarn-mjost-resourcemanager-tuca.out
127.0.0.1: starting nodemanager, logging to /home/mjost/opt/zips/hadoop-2.7.1/logs/yarn-mjost-nodemanager-tuca.out
10.0.0.10: starting nodemanager, logging to /home/mjost/opt/zips/hadoop-2.7.1/logs/yarn-mjost-nodemanager-ciccio.out
mjost@tuca:~/opt/hadoop$ jps
28784 org.apache.hadoop.yarn.server.nodemanager.NodeManager
28641 org.apache.hadoop.yarn.server.resourcemanager.ResourceManager
29097 sun.tools.jps.Jps
mjost@tuca:~/opt/hadoop$ 

```

In the server you should see the following processes: 

```
mjost@tuca:~$ jps
28784 org.apache.hadoop.yarn.server.nodemanager.NodeManager
28641 org.apache.hadoop.yarn.server.resourcemanager.ResourceManager
29242 sun.tools.jps.Jps
mjost@tuca:~$ 
```

While in the slaves you should see: 

```
mjost@ciccio:~/opt$ jps
7528 NodeManager
7663 Jps
mjost@ciccio:~/opt$ 
```

### Launch HDFS

Then you can launch HDFS: 

```
start-dfs.sh
```

## Run first example 

```
hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.1.jar wordcount / /tt
hdfs dfs -ls /tt

```

## Launch jobhistory server

```
mr-jobhistory-daemon.sh start historyserver 
```

