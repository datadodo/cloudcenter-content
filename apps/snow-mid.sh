#!/bin/bash -x
exec > >(tee -a /var/tmp/snow-mid-node-init_$$.log) 2>&1

. /usr/local/osmosix/etc/.osmosix.sh
. /usr/local/osmosix/etc/userenv
. /usr/local/osmosix/service/utils/cfgutil.sh
. /usr/local/osmosix/service/utils/agent_util.sh

sudo yum install -y unzip

cd /tmp
curl -o mid.zip "https://install.service-now.com/glide/distribution/builds/package/mid/2018/01/03/mid.kingston-10-17-2017__patch1-12-12-2017_01-03-2018_0843.linux.x86-64.zip"
sudo mkdir -p /servicenow/mid
sudo chown -R cliqruser:cliqruser /servicenow
cd /servicenow/mid
unzip /tmp/mid.zip
sed -i.bak -e "s?/YOUR_INSTANCE?/${snow_instance}?g" \
-e "s?YOUR_INSTANCE_USER_NAME_HERE?${snow_username}?g" \
-e "s?YOUR_INSTANCE_PASSWORD_HERE?${snow_password}?g" \
-e "s?YOUR_MIDSERVER_NAME_GOES_HERE?${parentJobName}?g" \
/servicenow/mid/agent/config.xml
cd agent
./start.sh
sudo /servicenow/mid/agent/bin/mid.sh install
