# README

This project aims to help you get started with your own yarn cluster. 

## Set environment

Add to your `~/.localrc` the following:

```
export HADOOP_HOME=$HOME/opt/hadoop
HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop/
export PATH=$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$PATH

```

## Ensure host names are available

Either user /etc/hosts or set up a DNS server.

## Set slaves

Modify the file `etc/hadoop/slaves` including all slave hosts' IP addresses.

## Start hadoop

### Format HDFS namenode
Before you can start using HDFS you need to format the namenode, doing.

```
rm -fr /tmp/hadoop-*      # in all datanode hosts and namenode hosts
hadoop namenode -format   # in namenode host only
```

Also ensure the location where HDFS storage is in the local filesystem is clean too (often in `/tmp/hadoop-user/dfs`.

### Launch YARN

Once this is done you can start by launching YARN:

```
./sbin/start-yarn.sh
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
./sbin/start-dfs.sh
```

It should log: 

```
mjost@tuca:~/opt/hadoop$ ./sbin/start-dfs.sh 
Starting namenodes on [10.0.0.2]
10.0.0.2: starting namenode, logging to /home/mjost/opt/zips/hadoop-2.7.1/logs/hadoop-mjost-namenode-tuca.out
127.0.0.1: starting datanode, logging to /home/mjost/opt/zips/hadoop-2.7.1/logs/hadoop-mjost-datanode-tuca.out
10.0.0.10: starting datanode, logging to /home/mjost/opt/zips/hadoop-2.7.1/logs/hadoop-mjost-datanode-ciccio.out
Starting secondary namenodes [0.0.0.0]
0.0.0.0: starting secondarynamenode, logging to /home/mjost/opt/zips/hadoop-2.7.1/logs/hadoop-mjost-secondarynamenode-tuca.out
mjost@tuca:~/opt/hadoop$ 

```

In the master: 

```
mjost@tuca:~$ jps
28784 org.apache.hadoop.yarn.server.nodemanager.NodeManager
29642 org.apache.hadoop.hdfs.server.namenode.NameNode
28641 org.apache.hadoop.yarn.server.resourcemanager.ResourceManager
30220 sun.tools.jps.Jps
30017 org.apache.hadoop.hdfs.server.namenode.SecondaryNameNode
29810 org.apache.hadoop.hdfs.server.datanode.DataNode
mjost@tuca:~$ 

```

In the slave:

```
mjost@ciccio:~/opt$ jps
7802 Jps
7726 DataNode
7528 NodeManager
mjost@ciccio:~/opt$ 
```

## Run first example 

```
hadoop dfsadmin -safemode leave
hdfs dfs -mkdir -p /data/input
hdfs dfs -put etc/hadoop/* /data/input
hdfs dfs -ls /data/input
hdfs fsck /data/input/slaves -files -blocks -locations
hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.1.jar wordcount /data/input /data/output

```

## See web portals

Web portals are often in: 

```
http://localhost:8088/cluster
http://localhost:8088/cluster/nodes
```
but you better follow URL shown by the job.

```
mjost@tuca:~/opt/hadoop$ hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.1.jar wordcount /data/input /data/output
16/02/08 21:13:19 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
16/02/08 21:13:20 INFO client.RMProxy: Connecting to ResourceManager at tuca/10.0.0.2:8032
16/02/08 21:13:21 INFO input.FileInputFormat: Total input paths to process : 30
16/02/08 21:13:22 INFO mapreduce.JobSubmitter: number of splits:30
16/02/08 21:13:22 INFO mapreduce.JobSubmitter: Submitting tokens for job: job_1454962387578_0001
16/02/08 21:13:23 INFO impl.YarnClientImpl: Submitted application application_1454962387578_0001
16/02/08 21:13:23 INFO mapreduce.Job: The url to track the job: http://tuca:8088/proxy/application_1454962387578_0001/
16/02/08 21:13:23 INFO mapreduce.Job: Running job: job_1454962387578_0001
16/02/08 21:13:30 INFO mapreduce.Job: Job job_1454962387578_0001 running in uber mode : false

```

If no nodes are listed you need to see the logs of your process to ensure everything is okay.

## Launch jobhistory server

```
mr-jobhistory-daemon.sh start historyserver 
```

