#!/bin/bash

yum install yum-utils -y
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo 
yum install terraform -y




