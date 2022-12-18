# jenkins-ec2-ecs
https://github.com/ppalit/jenkins-ec2-ecs/archive/refs/heads/main.zip

docker build -t jenkins_controller:1.0.1 .

docker run --name jenkins_controller1 --restart=on-failure --detach --privileged --publish 8080:8080 --publish 50000:50000 -e JENKINS_ADMIN_PASSWORD=adminn --volume jenkins-data:/var/jenkins_home --volume /var/run/docker.sock:/var/run/docker.sock jenkins_controller:1.0.1

