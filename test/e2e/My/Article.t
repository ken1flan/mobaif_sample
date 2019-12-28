use strict;
use warnings;
use utf8;

use Log::Log4perl qw(:easy);
use WWW::Mechanize::Chrome;
use Test::Spec;

use MobaConf;

describe 'My::Article' => sub {
  my $mech;

  before each => sub {
    $mech = WWW::Mechanize::Chrome->new(headless=> 1);
  };

  it 'TODO' => sub {
    $mech->get('http://127.0.0.1/my/articles');

    ok($mech->content =~ 'my/article');
  };

};
runtests unless caller;
