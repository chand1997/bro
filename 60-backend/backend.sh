#!/bin/bash

dnf install ansible -y

ansible-pull -i localhost, -U https://github.com/chand1997/expense-ansible-roles-tf.git main.yaml -e COMPONENT=backend -e ENVIRONMENT=$1


