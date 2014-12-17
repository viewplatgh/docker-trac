What's Trac
------
Trac is a project management software
For more details: http://trac.edgewall.org

What's idea of this repo
------
This is to host a bundle to create a docker container running Trac 

Steps to use
------
* Install docker
* Search and replace all 'docker-trac1A~' in repo files with your own password for MySQL and admin user
* Search and replace all 'docker-trac-demo' in repo files with your own project name
* Use your own deployment key, this is for your project git repo, you can use `ssh-keygen -t rsa -f deploy_key` to generate one
* Use your own ssh public key instead of 'key.pub', this is for ssh service of the container
* Edit 'git clone ...' in entrypoint.sh using your own project source repo
* Edit value of repository\_dir with your own project location in 'trac.ini'
* Run docker commands under this repo folder:
	`docker build -t NAME/TAG .`	
	`docker run -t NAME/TAG`   

Contributor
------ 
Rob Lao viewpl{at)gmail{dot)com http://roblao.com
