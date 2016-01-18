# README

## Set environment

Add to your `~/.localrc` the following:

```
export HADOOP_HOME=$HOME/opt/hadoop
HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop/
export PATH=$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$PATH

```

## Start hadoop

```
hadoop namenode -format
```

```
start-all.sh
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
