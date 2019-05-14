#!/usr/bin/perl
BEGIN { $ENV{MOBA_DIR} = '..'; }

use FCGI;
use Time::HiRes;

use strict;

use MobaConf;

my $count = 0;
my $request = FCGI::Request();

while($request->Accept() >= 0) {
    print("Content-type: text/html\r\n\r\n", ++$count);
    print(" $ENV{MOBA_DIR}");
    print(" $_::LOG_DIR");
}
