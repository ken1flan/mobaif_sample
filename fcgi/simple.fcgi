#!/usr/bin/perl
BEGIN { $ENV{MOBA_DIR} = '..'; }

use FCGI;
use Time::HiRes;

use strict;

use MobaConf;
my $config_file = "$ENV{MOBA_DIR}/conf/main.conf";
require $config_file;

my $count = 0;
my $request = FCGI::Request();

while($request->Accept() >= 0) {
    print("Content-type: text/html\r\n\r\n", ++$count);
    print(" $ENV{MOBA_DIR}");
    print(" $config_file");
    print(" $_::LOG_DIR");
}
