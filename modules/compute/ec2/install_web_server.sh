#!/bin/bash
sudo yum update -y
sudo yum install -y git
sudo yum install -y npm
sudo git clone https://github.com/Romarionijim/simple-express-code.git
cd simple-express-code
npm ci
node app.js