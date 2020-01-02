use strict;
use warnings;
use utf8;

use Log::Log4perl qw(:easy);
use WWW::Mechanize::Chrome;

use Test::Simple tests => 1;

my $mech = WWW::Mechanize::Chrome->new(headless=> 1);
$mech->get('http://127.0.0.1');
my $content = $mech->content;

ok( $content =~ /モバログ！/ );
