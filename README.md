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

###Step 3

Run the build script:

```
sh build.sh
```

You will be prompted to name your Maven Group and Artifact. Based on your Group ID, a default java package will be generated for you.

###Step 4

open Docker QuickStart Terminal
navigate to `brightspot-quickstart/build/context` directory
run `docker build -t $projectName .`

###Step 5

run `docker run -d -P $projectName`


###TODO:

- [ ] Provide scripts/Automate prereq installation
- [ ] Consolidate steps
- [ ] Use configuration files from archetype (located in `etc`)
- [ ] Automatically mount the project directory
