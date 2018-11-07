#!/bin/bash
# workstation requirements: Docker and Docker-Compose

concourse_docker_gitURL='https://github.com/concourse/concourse-docker/archive/master.zip'
use_local_compose_file=true # Not used
docker_compose_file='' 
: ${USE_SUDO:="true"}

runAsRoot() {
  local CMD="$*"

  if [ $EUID -ne 0 -a $USE_SUDO = "true" ]; then
    CMD="sudo $CMD"
  fi

  $CMD
}

is_docker_running()
{
    rep=$( runAsRoot curl -s --unix-socket /var/run/docker.sock http://ping > /dev/null )
      return $?
}

is_git_repo_avl()
{
     rep=$(wget ${concourse_docker_gitURL} -O- 2> /dev/null)
     return $?
}

shutdown_concourse()
{
    runAsRoot docker-compose -f ${docker_compose_file} down
}

start_concourse()
{
    runAsRoot docker-compose -f ${docker_compose_file} up -d
}

is_git_repo_avl
git_repo_avl=$?

if [ ${git_repo_avl} == "0" && ${use_local_compose_file} != "false" ]
   then 
        echo "Using latest version of docker-compose file from git..."
        wget -qO-  ${concourse_docker_gitURL} |  tar xvz
        docker_compose_file=$PWD/concourse-docker-master/docker-compose.yml
   else 
        echo "Using local copy of docker-compose file ..."
        docker_compose_file=$PWD/docker-compose.yml

fi

echo "Docker Compose File Path : $docker_compose_file"

is_docker_running
docker_running=$?
if [ $docker_running == "0" ]; 
 then 
    echo " Docker is running, Check OK ..."
 else 
    echo " Docker is not running, Please start docker daemon manually ..."
    exit -1 ; 
fi

shutdown_concourse
start_concourse
