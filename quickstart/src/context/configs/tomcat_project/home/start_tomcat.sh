#!/bin/bash

export CATALINA_HOME=/servers/tomcat
export CATALINA_BASE=`pwd`

export JPDA_ADDRESS=5080
export JAVA_OPTS="-Xms512m -Xmx1024m -Xrs -Djava.security.egd=file:/dev/./urandom"

${CATALINA_HOME}/bin/catalina.sh start

#tail -f logs/catalina.out

