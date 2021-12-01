#Automation Project - Dev Branch
s3_bucket="s3-course-assign-rajesh"
timestamp=$(date '+%d%m%Y-%H%M%S')
myname="rajesh"

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
tar -cvf /tmp/$myname-httpd-logs-$timestamp.tar /var/log/apache2/*.log
aws s3 cp /tmp/$myname-httpd-logs-$timestamp.tar s3://$s3_bucket/$myname-httpd-logs-$timestamp.tar
filename="/var/www/html/inventory.html"
if test -f "$filename"; then
    echo ""
else
        touch $filename
        echo -e "Log Type\tTime Created\tType\tSize" >> $filename
fi
accesssize=$(du -k /var/log/apache2/access.log | cut -f1)
errorsize=$(du -k /var/log/apache2/error.log | cut -f1)
othersize=$(du -k /var/log/apache2/other_vhosts_access.log | cut -f1)
numsum=`expr $accesssize + $errorsize + $othersize`
echo $numsum
filesize="$numsum K"
echo -e "httpd-logs\t$timestamp\ttar\t$filesize" >> $filename

