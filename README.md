## What's Trac
Trac is a project management software
For more details: http://trac.edgewall.org

## What's idea of this repo
This is to host a Dockerfile to create a linux system running Trac in it

## Before use
* Install docker

## Steps to use
* To build and run default container, go to the repo dir, type and enter two commands
	`docker build -t TAG/NAME .`
	`docker run -t TAG/NAME` 
* Well, some customization maybe needed before build & run. At least, the public key need to be changed to the one you created on your machine
* Default project name 'docker-trac-demo'and mysql password 'docker-trac1A~' may need to be changed as well

## Contributor 
Rob Lao viewpl{at)gmail{dot)com http://roblao.com

