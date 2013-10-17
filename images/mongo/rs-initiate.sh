#!/bin/bash

#/usr/bin/mongod --replSet rs0 --oplogSize 100 --rest --smallfiles --noprealloc --dbpath /data --logpath /logs/mongod.log --fork

echo "waiting for mongo"
until /mongodb/bin/mongo --eval "print(1);" > /dev/null 2>&1
do
	echo -n .
	sleep 1
done

echo "initiating rs"
/mongodb/bin/mongo --eval 'printjson(rs.initiate({ _id: "rs0", members: [ { _id: 0, host: "localhost:27017" } ] }))' --quiet

# echo "waiting for rs"
# while [ "`mongo --eval "rs.status().myState" --quiet`" -ne 1 ]
# do
# 	echo -n .
# 	sleep 1
# done

# echo "loading default data"
# /usr/bin/mongorestore /mongo/defaultdata

# # necessary to block to keep the container running
# tail -f /logs/mongod.log
