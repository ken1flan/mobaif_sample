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

describe 'Article' => sub {
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

  it '自分の記事一覧を見ることができること' => sub {
    $mech->get("http://127.0.0.1/articles");

    ok($mech->content =~ 'user article title');
    ok($mech->content =~ 'other article title');
  };

  it '記事を見ることができること' => sub {
    $mech->get("http://127.0.0.1/articles/$user_article->{id}");

    ok($mech->content =~ 'user article title');
    ok($mech->content =~ 'foobar');
    ok($mech->content =~ 'user article body');
  };
};

runtests unless caller;
