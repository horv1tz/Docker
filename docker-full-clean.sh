docker rm $(docker kill $(docker ps -aq))
docker rmi $(docker images -aq)
