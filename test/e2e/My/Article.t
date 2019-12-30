use strict;
use warnings;
use utf8;

use Log::Log4perl qw(:easy);
use WWW::Mechanize::Chrome;
use Test::Spec;

use MobaConf;

use DA;
use Func::User;

describe 'My::Article' => sub {
  my $mech;
  my $dbh;

  before each => sub {
    $mech = WWW::Mechanize::Chrome->new(headless=> 1);
    $dbh = DA::getHandle($_::DB_USER_W);

    Func::User::create({ nickname => 'foobar', email => 'foobar@example.com', password => 'password' });
    DA::commit()
  };

  after each => sub {
    $dbh->do('TRUNCATE TABLE user_data;');
    $dbh->do('TRUNCATE TABLE articles;');
  };

  context 'ログインしていないとき' => sub {
    it '記事を登録できないこと' => sub {
      $mech->get('http://127.0.0.1/my/articles/new');

      ok($mech->content =~ 'ログインが必要です。');
    };
  };

  context 'ログインしているとき' => sub {
    before each => sub {
      $mech->get('http://127.0.0.1/session/new');
      $mech->set_fields(email=> 'foobar@example.com', password=> 'password');
      $mech->click('login');
    };

    it '記事を登録できること' => sub {
      $mech->get('http://127.0.0.1/my/articles/new');
      ok($mech->content =~ '記事作成');

      $mech->click('submit');
      ok($mech->content =~ 'エラーがあります。');

      $mech->form_number(1);
      $mech->set_fields(title=> 'article title', body=> 'article body');
      $mech->click('submit');

      ok($mech->content =~ '登録しました。');
      ok($mech->content =~ 'article title');
      ok($mech->content =~ 'article body');
    };
  };
};
runtests unless caller;
