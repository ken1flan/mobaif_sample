#!/usr/bin/perl
use FCGI;
use Time::HiRes;

use strict;

# use MobaConf;
# $ENV{MOBA_DIR} = "/usr/local/lib/mobalog";
my $config_file = "$ENV{MOBA_DIR}/conf/main.conf";

my $count = 0;
my $request = FCGI::Request();

while($request->Accept() >= 0) {
    print("Content-type: text/html\r\n\r\n", ++$count);
    print(" $ENV{MOBA_DIR}");
    print(" $config_file");
}
