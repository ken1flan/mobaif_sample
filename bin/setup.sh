#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
PROJECT_DIR=${SCRIPT_DIR}/..

chmod -R a+w data

carton install

mysql -h mariadb -u root < ${PROJECT_DIR}/conf/createdb.sql
