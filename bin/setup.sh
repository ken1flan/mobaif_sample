#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
PROJECT_DIR=${SCRIPT_DIR}/..

carton install

mysql -h mariadb -u root < ${PROJECT_DIR}/conf/createdb.sql
