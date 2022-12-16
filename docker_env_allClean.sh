echo " stopping all compose stacks.."
find /Users/ppalit/1MyFiles/repo -name '*docker-compose*' -exec docker-compose -f {} down \;
echo " stopping all containers.."
docker kill $(docker ps -q)
echo " removing all  containers.."
docker rm -f $(docker ps -a -q) 
echo " removing all volumes.."
docker volume rm $(docker volume ls -q)
echo " removing all  networks"
docker network rm $(docker network ls -q)
echo " removing all  images"
docker rmi -f $(docker images -a -q)
