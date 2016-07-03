PATTERN=`date +%Y%m%d -d "32 days ago"`
sed -i '/$PATTERN/d' /var/log/skad_dog.log

