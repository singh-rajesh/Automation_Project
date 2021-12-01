#Automation Project
s3_bucket="s3-course-assign-rajesh"
timestamp=$(date '+%d%m%Y-%H%M%S')

sudo apt update -y

apachev=$(which apache2)
if [ -z "$apachev" ]
then
	sudo apt install apache2
fi

apachec=$(apachectl configtest)
if [ "$apachec" == "Syntax OK" ]
then
        systemctl start apache2
fi

apacheen=$(systemctl status apache2 | grep active)
if [ "$apacheen" == "Active: active*" ]
then
        systemctl enable apache2
fi
tar -cvf /tmp/rajesh-httpd-logs-$timestamp.tar /var/log/apache2/*.log
aws s3 cp /tmp/rajesh-httpd-logs-$timestamp.tar s3://$s3_bucket/rajesh-httpd-logs-$timestamp.tar
