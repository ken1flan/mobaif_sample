use strict;
use warnings;
use utf8;

use Log::Log4perl qw(:easy);
use WWW::Mechanize::Chrome;
use Test::Spec;

use MobaConf;

use DA;
use Func::User;

describe 'Welcome' => sub {
  my $mech;

  before each => sub {
    $mech = WWW::Mechanize::Chrome->new(headless=> 1);

    Func::User::create({ nickname => 'foobar', email => 'foobar@example.com', password => 'password' });
    DA::commit()
  };

  it 'ログインしていないときにWelcomeページを訪れる' => sub {
    $mech->get('http://127.0.0.1/_welcome');

    my $content = $mech->content;
    ok($mech->content =~ 'ログインが必要です。');
    ok($mech->content =~ 'ユーザ登録');
    ok($mech->content =~ 'ログイン');
  };

  it 'ログインしてからWelcomeパージを訪れる' => sub {
    $mech->get('http://127.0.0.1/session/new');
    $mech->set_fields(email=> 'foobar@example.com', password=> 'password');
    $mech->click('login');
    ok($mech->content =~ 'ログインしました。');

    $mech->get('http://127.0.0.1/_welcome');
    ok($mech->content =~ 'ログインしています。');
  };
};

runtests unless caller;
