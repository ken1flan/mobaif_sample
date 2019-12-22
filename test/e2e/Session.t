use strict;
use warnings;
use utf8;

use Log::Log4perl qw(:easy);
use WWW::Mechanize::Chrome;
use Test::Spec;

use MobaConf;

use DA;
use Func::User;

describe 'Session' => sub {
  my $mech;

  before each => sub {
    $mech = WWW::Mechanize::Chrome->new(headless=> 1);

    Func::User::create({ nickname => 'foobar', email => 'foobar@example.com', password => 'password' });
    DA::commit();
  };

  after each => sub {
    my $dbh = DA::getHandle($_::DB_USER_W);
    $dbh->do('TRUNCATE TABLE user_data;');
  };

  it 'ログインができること' => sub {
    # ログインページを訪れる。
    $mech->get('http://127.0.0.1/session/new');

    # 誤った認証情報を入力する。
    $mech->set_fields(email=> 'foobar@example.com', password=> 'passw0rd');
    $mech->click('login');
    ok($mech->content =~ 'Eメールまたはパスワードが間違っています。');

    # 正しい認証情報を入力する。
    $mech->get_set_value(name=> 'password', value=> 'password');
    $mech->click('login');
    ok($mech->content =~ 'ログインしました。');
  };

};
runtests unless caller;
