#Brightspot Quickstart

###Step 1

Clone repository

###Step 2

[Install Docker Toolbox](https://www.docker.com/docker-toolbox) 

###Step 3

run `sh build.sh`

And answer prompts for project naming

###Step 4

open Docker QuickStart Terminal
navigate to your `build/context` directory
run `docker build -t $projectName .`

###Step 5

run `docker run -d -P $projectName`


###TODO:

- [ ] Automate docker toolbox installation 
- [ ] Consolidate multiple steps
- [ ] Use configuration files from archetype (located in `etc`)
- [ ] Automatically mount the project directory
