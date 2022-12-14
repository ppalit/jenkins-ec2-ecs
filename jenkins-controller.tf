resource "aws_security_group" "jenkins" {
  name   = "jenkins"
  vpc_id = "vpc-06d21722a8226df62"

  // To Allow SSH Transport
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    protocol    = "tcp"
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 0
    protocol  = -1
    to_port   = 0
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "jenkins_master" {
  name = "jenkins_master"

  assume_role_policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonECS_FullAccess"]

}



resource "aws_iam_instance_profile" "jenkins_master" {
  name = "jenkins_master"
  role = aws_iam_role.jenkins_master.name
}

resource "aws_instance" "jenkins_master" {
  ami                  = "ami-0b0dcb5067f052a63"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.jenkins_master.name
  vpc_security_group_ids = [
    aws_security_group.jenkins.id
  ]

  root_block_device {
    delete_on_termination = true
    volume_size           = 20
    volume_type           = "gp2"
  }

  user_data = <<EOF
    #!/bin/bash
    yum update -y
    yum install docker -y
    usermod -a -G docker ec2-user
    id ec2-user
    usermod -a -G docker jenkins
    id jenkins
    newgrp docker
    yum install python3-pip
    pip3 install docker-compose
    systemctl enable docker.service
    systemctl start docker.service
    #do this till you find a better sol to build docker images on the same host or use other hosts
    chmod 777 /var/run/docker.sock
    EOF
}
/*
resource "aws_instance" "linux_agent" {
  ami           = "ami-0b0dcb5067f052a63"
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    aws_security_group.example.id
  ]

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp2"
  }

  user_data = <<EOF
    #!/bin/bash
    yum update -y
    yum install docker -y
    usermod -a -G docker jenkins
    id jenkins
    newgrp docker
    yum install python3-pip
    pip3 install docker-compose
    systemctl enable docker.service
    systemctl start docker.service
    EOF

}

resource "aws_instance" "win" {
  ami               = "ami-06371c9f2ad704460"
  instance_type     = "t2.micro"
  vpc_security_group_ids = [
    aws_security_group.example.id
  ]

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp2"
  }

    user_data = <<EOF
    #!/bin/bash
    yum update -y
    yum install docker -y
    usermod -a -G docker ec2-user
    id ec2-user
    newgrp docker
    yum install python3-pip
    pip3 install docker-compose
    systemctl enable docker.service
    systemctl start docker.service
    systemctl status docker.service
    EOF

}

*/
output "ec2instance" {
  value = aws_instance.jenkins_master.public_ip
}