#!/bin/sh

OPT="-fPIC -O2 -Wuninitialized"

rm -f *.o
rm -f libmcode.a
gcc ${OPT} -c libmcode.c
ar rc libmcode.a *.o
rm -f *.o

echo "MAKE libmcode.a finished"
