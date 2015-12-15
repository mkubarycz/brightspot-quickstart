#Brightspot Quickstart

This repository is meant to provide an easy way to start a new Brightspot project.

Here is a quick list of what this can do for you:

* Build a new project from the archetype
* Generate a docker container for your project
* Configure your tomcat and databases
* Run your project in a docker machine

##Prereqs

1. Have [Java 8+](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) installed
2. Have [Maven 3.3+](https://maven.apache.org/download.cgi) installed
3. Have [Docker Toolbox](https://www.docker.com/docker-toolbox) installed

##Creating Your Brightspot Project

####Step 1

Clone this repository:

```
git clone https://github.com/rhino88/brightspot-quickstart.git
```

####Step 2

Navigate to the `brightspot-quickstart` directory:

```
cd brightspot-quickstart
```

####Step 3

Run the build script:

```
sh build.sh
```

You will be prompted to name your Maven Group and Artifact. Based on your Group ID, a default java package will be generated for you.

After running this command, you should have the following:

```
build/
	context/ Your Docker context
	distro/ Apache, Mysql connector, and solr downloads
	project/ Contains your new project generated by the Brightspot Maven Archetype
```

##Running your project with Docker

* open Docker QuickStart Terminal
* navigate to `brightspot-quickstart/build/context` directory
* run `docker build -t $projectName .`
* run:
```
 docker run -d -p 8080:8080 -v `pwd`/project/$projectName:/project/$projectName $projectName
```
* run `docker-machine env default` to get your IP address. The result should look something like this:

```
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.100:2376"
export DOCKER_CERT_PATH="path/to/cert"
export DOCKER_MACHINE_NAME="default"
```

Use the DOCKER_HOST IP Address in your browser to view your virtual server running Brighspot!

http://192.168.99.100:8080/cms (the home page will be a 404, since we haven't set up a home page yet)


###TODO:

- [ ] Provide scripts/Automate prereq installation
- [ ] Consolidate steps
- [ ] Use configuration files from archetype (located in `etc`)
- [ ] Run maven archetype in Dockerfile instead of in build
