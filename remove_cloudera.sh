#!/bin/bash
service cloudera-scm-server stop
service cloudera-scm-agent stop

sh /usr/share/cmf/uninstall-cloudera-manager.sh

yum remove 'cloudera-manager-*'
yum clean

for comp in cloudera-scm flume hadoop hdfs hbase hive httpfs hue impala llama mapred oozie solr spark sqoop sqoop2 yarn zookeeper;
do
  kill $(ps -u $comp -o pid=);
done

umount cm_processes
rm -rf /usr/share/cmf /var/lib/cloudera* /var/cache/yum/cloudera* /var/log/cloudera* /var/run/cloudera*

rm /tmp/.scm_prepare_node.lock

rm -rf /var/lib/flume-ng /var/lib/hadoop* /var/lib/hue /var/lib/navigator /var/lib/oozie /var/lib/solr /var/lib/sqoop* /var/lib/zookeeper

rm -rf /dfs/yarn

echo "Done"

reboot
