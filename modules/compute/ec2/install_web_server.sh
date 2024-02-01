#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo amazon-linux-extras install -y docker
sudo systemctl enable --now docker
sudo yum install -y ecs-init
sudo systemctl enable --now ecs