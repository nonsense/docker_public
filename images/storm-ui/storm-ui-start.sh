#!/bin/bash


HOST=`hostname`
echo "127.0.0.1 $HOST" >> /etc/hosts

echo "ZOOKEEPER_IP=$ZOOKEEPER_IP"
echo "Fixing ZOOKEEPER_IP in server.properties"
sed -i "s/{{ZOOKEEPER_IP}}/${ZOOKEEPER_IP}/g" /storm/conf/storm.yaml

echo "NIMBUS_IP=$NIMBUS_IP"
echo "Fixing NIMBUS_IP in server.properties"
sed -i "s/{{NIMBUS_IP}}/${NIMBUS_IP}/g" /storm/conf/storm.yaml

echo "Starting storm ui"
nohup /storm/bin/storm ui

# echo "Strarting storm ui"
# nohup /storm/bin/storm ui > /logs/storm-ui.log 2>&1 &

# app_jar="LucidEventsProcessing-0.0.1-SNAPSHOT-jar-with-dependencies.jar"
# topology_runner="com.relateiq.storm.TopologyRunner"
# install_dir="/storm"

# # kill off topologies first (they get 60s to wrap up)
# echo "Killing topologies"
# $install_dir/storm_util.sh kill Crawler
# $install_dir/storm_util.sh kill Cron
# $install_dir/storm_util.sh kill Messaging
# $install_dir/storm_util.sh kill IQ
# $install_dir/storm_util.sh kill IQ_OFFLINE
# $install_dir/storm_util.sh kill OnBoarding
# $install_dir/storm_util.sh kill CompanyCorpus
# $install_dir/storm_util.sh kill Contribution

# echo "Swapping jars"
# $install_dir/storm_util.sh swapjar Crawler $app_jar $topology_runner com.relateiq.crawler.CrawlerTopology
# $install_dir/storm_util.sh swapjar Cron $app_jar $topology_runner com.relateiq.cron.CronTopology
# $install_dir/storm_util.sh swapjar Messaging $app_jar $topology_runner com.relateiq.messaging.MessagingTopology
# $install_dir/storm_util.sh swapjar IQ $app_jar $topology_runner com.relateiq.iq.IQEventTopology
# $install_dir/storm_util.sh swapjar IQ_OFFLINE $app_jar $topology_runner com.relateiq.iq.IQOfflineTopology
# $install_dir/storm_util.sh swapjar OnBoarding $app_jar $topology_runner com.relateiq.onboarding.OnBoardingTopology
# $install_dir/storm_util.sh swapjar CompanyCorpus $app_jar $topology_runner com.relateiq.company.CompanyCorpusTopology
# $install_dir/storm_util.sh swapjar Contribution $app_jar $topology_runner com.relateiq.contributions.ContributionTopology

# tail -f /logs/nimbus.log