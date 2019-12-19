use strict;
use warnings;
use utf8;

use Log::Log4perl qw(:easy);
use WWW::Mechanize::Chrome;
use Test::Spec;

use MobaConf;
use DA;

describe 'Regist user' => sub {
  my $mech;

  before each => sub {
    $mech = WWW::Mechanize::Chrome->new(headless=> 1);
  };

  it 'is expected to visit /session/new' => sub {
    $mech->get('http://127.0.0.1/session/new');
    my $content = $mech->content;
    ok($mech->content =~ 'New');
  };

};
runtests unless caller;
