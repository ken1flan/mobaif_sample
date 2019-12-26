use strict;
use utf8;

use MobaConf;
use Test::Spec;

use Func::Article;

use Data::Dumper;
use DA;

describe 'Func::Article' => sub {
  my $dbh = DA::getHandle($_::DB_USER_W);
  after each => sub {
    $dbh->do('TRUNCATE TABLE articles;');
  };

  describe 'find' => sub {
    before each => sub {
      my $params = {user_id => 1, title => 'some title', body => 'about something'};
      Func::Article::create($params);
      DA::commit();
    };

    it '取得できること' => sub {
      my $article = Func::Article::find(1);

      ok($article->{user_id} == 1);
      ok($article->{title} eq 'some title');
      ok($article->{body} eq 'about something');
    };
  };

  describe 'search_by_user_id' => sub {

    it 'TODO' => sub {
      # TODO
      ok(1);
    };
  };

  describe 'verify' => sub {

    it 'TODO' => sub {
      # TODO
      ok(1);
    };
  };

  describe 'create' => sub {
    my $params = {user_id => 1, title => 'some title', body => 'about something'};

    it '登録されること' => sub {
      Func::Article::create($params);
      DA::commit();

      my $article = Func::Article::find(1);
      ok($article->{user_id} == 1);
      ok($article->{title} eq 'some title');
      ok($article->{body} eq 'about something');
    };
  };

  describe 'update' => sub {

    it 'TODO' => sub {
      # TODO
      ok(1);
    };
  };

  describe 'destroy' => sub {

    it 'TODO' => sub {
      # TODO
      ok(1);
    };
  };
};

runtests unless caller;
