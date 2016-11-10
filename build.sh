#!/bin/bash
set -e

BUILD=build
DISTRO=$BUILD/distro
CONTEXT=$BUILD/context
PROJECT=$CONTEXT/project
TOMCAT_PROJECT=$CONTEXT/configs/tomcat_project
TOMCAT_SOLR=$CONTEXT/configs/tomcat_solr

echo "Artifact Group ID? : "
read groupId
echo "Artifact Name? :"
read artifactName

# create a place to store all dynamically fetched resources
mkdir -p $DISTRO

# copy the baseline docker context from src
echo "Copying src context into Docker context..."
cp -r src/context build/

# change placeholders to your project name
sed -i.bak "s/{{projectName}}/$artifactName/g" $CONTEXT/Dockerfile
sed -i.bak "s/{{projectName}}/$artifactName/g" $CONTEXT/configs/tomcat_project/conf/context.xml
sed -i.bak "s/{{projectName}}/$artifactName/g" $CONTEXT/configs/apache/conf-enabled/dims.conf

# download tomcat and place in the build context distro directory
if [ -d $DISTRO/apache-tomcat-8.0.14 ]; then
    echo "Tomcat has already been downloaded!"
else
    echo "Downloading tomcat..."
    curl -SL http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.14/bin/apache-tomcat-8.0.14.tar.gz | tar -xzC $DISTRO
    #tar -xzf temp/apache-tomcat-8.0.14.tar.gz -C $DISTRO
fi

echo "Moving Tomcat files into Docker context..."
mkdir -p $CONTEXT/distro
cp -r $DISTRO/apache-tomcat-8.0.14 $CONTEXT/distro/tomcat
tar -czf $CONTEXT/distro/tomcat.tar.gz -C $CONTEXT/distro tomcat
rm -rf $CONTEXT/distro/tomcat

# download mysql conntector jar and place it in the project's tomcat lib directory
if [ -d $DISTRO/mysql-connector-java-5.1.37 ]; then
    echo "MySQL connector JAR has already been downloaded!"
else
    echo "Downloading MySQL connector JAR..."
    curl -SL http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.37.tar.gz | tar -xzC $DISTRO
    #tar -xzf temp/mysql-connector-java-5.1.37.tar.gz -C $DISTRO
fi

echo "Moving MySQL connector JAR into Docker context..."
mkdir -p $TOMCAT_PROJECT/lib
cp $DISTRO/mysql-connector-java-5.1.37/mysql-connector-java-5.1.37-bin.jar $TOMCAT_PROJECT/lib/

# download solr and extract out the relevant parts
if [ -d $DISTRO/solr-4.8.1 ]; then
    echo "Solr has already been downloaded!"
else
    echo "Downloading Solr..."
    curl -SL http://archive.apache.org/dist/lucene/solr/4.8.1/solr-4.8.1.tgz | tar -xzC $DISTRO
    #tar -xzf temp/solr-4.8.1.tgz -C $DISTRO
fi

echo "Moving Solr files into Docker context..."
mkdir -p $TOMCAT_SOLR/lib/ $TOMCAT_SOLR/webapps/
cp $DISTRO/solr-4.8.1/example/webapps/solr.war $TOMCAT_SOLR/webapps/
cp $DISTRO/solr-4.8.1/example/lib/ext/* $TOMCAT_SOLR/lib/
cp $DISTRO/solr-4.8.1/example/resources/* $TOMCAT_SOLR/lib/
cp -r $DISTRO/solr-4.8.1/example/solr $TOMCAT_SOLR/

echo "Moving Dari Solr schema files into Docker context..."
cp src/distro/config-5.xml $TOMCAT_SOLR/solr/collection1/conf/solrconfig.xml
cp src/distro/schema-12.xml $TOMCAT_SOLR/solr/collection1/conf/schema.xml

# build the project from archetype
mkdir -p $PROJECT
cd $PROJECT
mvn archetype:generate -B \
    -DarchetypeRepository=https://artifactory.psdops.com/public \
    -DarchetypeGroupId=com.psddev \
    -DarchetypeArtifactId=cms-app-archetype \
    -DarchetypeVersion=3.1-SNAPSHOT \
    -DgroupId=$groupId \
    -DartifactId=$artifactName

cd $artifactName

mvn generate-resources
# Brightspot Base
#target/bin/grunt install-library --endpoint perfectsense/brightspot-base#master
mvn clean package

echo "Moving WAR file into Docker context..."
cp target/*.war ../../distro/$artifactName.war

echo "DONE!"
