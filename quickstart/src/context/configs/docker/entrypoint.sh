#!/bin/bash

# install code
cd /project/$PROJECT_NAME/
mvn clean package
cp /project/$PROJECT_NAME/target/*.war /servers/$PROJECT_NAME/webapps/ROOT.war

/etc/init.d/mysql start
(cd /servers/solr; ./start_tomcat.sh)
(cd /servers/$PROJECT_NAME; ./start_tomcat.sh)
/usr/sbin/apache2ctl start

tail -f /servers/$PROJECT_NAME/logs/catalina.out

#/usr/sbin/apache2ctl -D FOREGROUND

