#!/bin/bash -x
exec > >(tee -a /var/tmp/wp-bkup_$$.log) 2>&1

. /usr/local/osmosix/etc/.osmosix.sh
. /usr/local/osmosix/etc/userenv
. /usr/local/osmosix/service/utils/cfgutil.sh
cd ~

echo "Username: $(whoami)"
echo "Working Directory: $(pwd)"

env

 #Install S3
sudo wget -N "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip"
sudo unzip -o awscli-bundle.zip
sudo ./awscli-bundle/install -b /root/bin/aws

#Configure S3
sudo mkdir -p /root/.aws
echo "[default]" | sudo tee --append /root/.aws/config
echo "region=us-west-1" | sudo tee --append /root/.aws/config
echo "output=json" | sudo tee --append /root/.aws/config
echo "[default]" | sudo tee --append /root/.aws/credentials
echo "aws_access_key_id=$aws_access_key_id" | sudo tee --append /root/.aws/credentials
echo "aws_secret_access_key=$aws_secret_access_key" | sudo tee --append /root/.aws/credentials

cd /var/www/wordpress

sudo zip -r ~/wordpressbkup.zip *

sudo /root/bin/aws s3 cp ~/wordpressbkup.zip s3://$s3path/$CliqrDeploymentId/wordpressbkup.zip

sudo rm ~/wordpressbkup.zip
