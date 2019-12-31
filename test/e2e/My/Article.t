use strict;
use warnings;
use utf8;

use Log::Log4perl qw(:easy);
use WWW::Mechanize::Chrome;
use Test::Spec;

use MobaConf;

use DA;
use Func::Article;
use Func::User;

describe 'My::Article' => sub {
  my $mech;
  my $dbh;

  my $user;
  my $other;
  my $user_article;
  my $other_article;

  before each => sub {
    $mech = WWW::Mechanize::Chrome->new(headless=> 1);
    $dbh = DA::getHandle($_::DB_USER_W);

    Func::User::create({ nickname => 'foobar', email => 'foobar@example.com', password => 'password' });
    Func::User::create({ nickname => 'other', email => 'other@example.com', password => 'password' });
    DA::commit();
    $user = Func::User::find_by_email('foobar@example.com');
    $other = Func::User::find_by_email('other@example.com');

    Func::Article::create({ title=>'user article title', body=> 'user article body', user_id=>$user->{user_id}} );
    Func::Article::create({ title=>'other article title', body=> 'other article body', user_id=>$other->{user_id}} );
    DA::commit();

    $user_article = Func::Article::find_last_by_user_id($user->{user_id});
    $other_article = Func::Article::find_last_by_user_id($other->{user_id});
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

    it '記事一覧を見れないこと' => sub {
      $mech->get("http://127.0.0.1/my/articles/$user_article->{id}");

      ok($mech->content =~ 'ログインが必要です。');
    };

    it '記事を見れないこと' => sub {
      $mech->get("http://127.0.0.1/my/articles/$user_article->{id}");

      ok($mech->content =~ 'ログインが必要です。');
    };

    it '記事を編集できないこと' => sub {
      $mech->get("http://127.0.0.1/my/articles/$user_article->{id}/edit");

      ok($mech->content =~ 'ログインが必要です。');
    };

    it '記事を削除できないこと' => sub {
      $mech->get("http://127.0.0.1/my/articles/$user_article->{id}/destroy");

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

    it '自分の記事一覧を見ることができること' => sub {
      $mech->get("http://127.0.0.1/my/articles");

      ok($mech->content =~ 'user article title');
      ok($mech->content !~ 'other article title');
    };

    it '自分の記事を見ることができること' => sub {
      $mech->get("http://127.0.0.1/my/articles/$user_article->{id}");

      ok($mech->content =~ 'user article title');
      ok($mech->content =~ 'user article body');
    };

    it '他の人の記事を見ることができないこと' => sub {
      $mech->get("http://127.0.0.1/my/articles/$other_article->{id}");

      ok($mech->content =~ '見ることができません。');
    };

    it '記事を編集できること' => sub {
      $mech->get("http://127.0.0.1/my/articles/$user_article->{id}/edit");
      ok($mech->content =~ '記事編集');

      $mech->form_number(1);
      $mech->set_fields(title=> '', body=> 'updated article body');
      $mech->click('submit');
      ok($mech->content =~ 'エラーがあります。');

      $mech->form_number(1);
      $mech->set_fields(title=> 'updated article title', body=> 'updated article body');
      $mech->click('submit');

      ok($mech->content =~ '更新しました。');
      ok($mech->content =~ 'updated article title');
      ok($mech->content =~ 'updated article body');
    };

    it '他の人の記事を編集できないこと' => sub {
      $mech->get("http://127.0.0.1/my/articles/$other_article->{id}/edit");

      ok($mech->content =~ '編集することができません。');
    };

    it '記事を削除できること' => sub {
      $mech->get("http://127.0.0.1/my/articles/$user_article->{id}/destroy");

      ok($mech->content =~ '削除しました。');
      ok($mech->content !~ 'user article title');
    };

    it '他の人の記事を削除できないこと' => sub {
      $mech->get("http://127.0.0.1/my/articles/$other_article->{id}/destroy");

      ok($mech->content =~ '削除することができません。');
    };
  };
};

runtests unless caller;
