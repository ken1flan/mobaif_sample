#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
PROJECT_DIR=${SCRIPT_DIR}/..

carton install

XS_DIR=${PROJECT_DIR}/src/xs
cd $XS_DIR && ./makexs MobaConf && ./makexs MTemplate && ./makexs SoftbankEncode && ./makexs HTMLFast && cd -
