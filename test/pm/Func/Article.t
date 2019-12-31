use strict;
use utf8;

use MobaConf;
use Test::Spec;

use Func::Article;

use Data::Dumper;
use DA;
use Func::User;

describe 'Func::Article' => sub {
  my $dbh = DA::getHandle($_::DB_USER_W);
  after each => sub {
    $dbh->do('TRUNCATE TABLE articles;');
    $dbh->do('TRUNCATE TABLE user_data;');
  };

  describe 'find' => sub {
    my $user = undef;

    before each => sub {
      Func::User::create({ nickname => 'foobar', email => 'foobar@example.com', password => 'password' });
      DA::commit();
      $user = Func::User::find_by_email('foobar@example.com');

      my $params = {user_id => $user->{user_id}, title => 'some title', body => 'about something'};
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

  describe 'find_last_by_user_id' => sub {
    my $user_id = undef;
    my $author = undef;
    my $other = undef;

    before each => sub {
      Func::User::create({ nickname => 'author', email => 'author@example.com', password => 'password' });
      Func::User::create({ nickname => 'other', email => 'other@example.com', password => 'password' });
      DA::commit();

      $author = Func::User::find_by_email('author@example.com');
      $other = Func::User::find_by_email('other@example.com');

      Func::Article::create({user_id => $author->{user_id}, title => 'author article 1', body => 'about author article 1'});
      Func::Article::create({user_id => $author->{user_id}, title => 'author article 2', body => 'about author article 2'});
      DA::commit();
    };

    context 'user_id = undef のとき' => sub {
      before each => sub {
        $user_id = undef;
      };

      it 'undefであること' => sub {
        my $article = Func::Article::find_last_by_user_id($user_id);

        ok(!defined($article));
      };
    };

    context 'user_id = other.user_id のとき' => sub {
      before each => sub {
        $user_id = $other->{user_id};
      };

      it 'undefであること' => sub {
        my $article = Func::Article::find_last_by_user_id($user_id);

        ok(!defined($article));
      };
    };

    context 'user_id = author.user_id のとき' => sub {
      before each => sub {
        $user_id = $author->{user_id};
      };

      it 'あとから登録した記事であること' => sub {
        my $article = Func::Article::find_last_by_user_id($user_id);

        ok($article->{title} eq 'author article 2');
        ok($article->{body} eq 'about author article 2');
      };
    };
  };

  describe 'search_by_user_id' => sub {
    my $user_id = undef;
    my $other = undef;
    my $author1 = undef;
    my $author2 = undef;

    before each => sub {
      Func::User::create({ nickname => 'other', email => 'other@example.com', password => 'password' });
      Func::User::create({ nickname => 'author1', email => 'author1@example.com', password => 'password' });
      Func::User::create({ nickname => 'author2', email => 'author2@example.com', password => 'password' });
      DA::commit();

      $other = Func::User::find_by_email('other@example.com');
      $author1 = Func::User::find_by_email('author1@example.com');
      $author2 = Func::User::find_by_email('author2@example.com');

      Func::Article::create({user_id => $author1->{user_id}, title => 'author1 article 1', body => 'about author1 article'});
      Func::Article::create({user_id => $author2->{user_id}, title => 'author2 article 1', body => 'about author2 article'});
      Func::Article::create({user_id => $author2->{user_id}, title => 'author2 article 2', body => 'about author2 article'});
      DA::commit();
    };

    context 'user_id = ArticleのないUserのIDのとき' => sub {
      before each => sub {
        $user_id = $other->{user_id};
      };

      it '空の配列であること' => sub {
        my $rows = Func::Article::search_by_user_id($user_id);

        ok(!@$rows);
      };
    };

    context 'user_id = Articleを1つ持つUserのIDのとき' => sub {
      before each => sub {
        $user_id = $author1->{user_id};
      };

      it 'Articleが指定されたuser_idのものであること' => sub {
        my $rows = Func::Article::search_by_user_id($user_id);

        ok(scalar(@$rows) == 1);
        my $article = $rows->[0];
        ok($article->{user_id} == $user_id);
      };
    };

    context 'user_id = Articleを2つ持つUserのIDのとき' => sub {
      before each => sub {
        $user_id = $author2->{user_id};
      };

      it 'Articleが指定されたuser_idのものであること' => sub {
        my $rows = Func::Article::search_by_user_id($user_id);

        foreach my $article (@$rows) {
          ok($article->{user_id} == $user_id);
        }
      };
    };
  };

  describe 'validate' => sub {
    my $params = {};
    my $user = undef;

    before each => sub {
      Func::User::create({ nickname => 'foobar', email => 'foobar@example.com', password => 'password' });
      DA::commit();
      $user = Func::User::find_by_email('foobar@example.com');
    };

    describe 'user_id' => sub {
      context 'user_id = undefのとき' => sub {
        before each => sub {
          $params = {user_id => undef};
        };

        it 'ErrUserIdPresenceが設定されていること' => sub {
          my $errors = Func::Article::validate($params);

          ok($errors->{ErrUserIdPresence} == 1);
        };
      };

      context 'user_id = 存在しないidのとき' => sub {
        before each => sub {
          $params = {user_id => 99999};
        };

        it 'ErrUserIdInvalidが設定されていること' => sub {
          my $errors = Func::Article::validate($params);

          ok($errors->{ErrUserIdInvalid} == 1);
        };
      };

      context 'user_id = 存在するidのとき' => sub {
        before each => sub {
          $params = {user_id => $user->{user_id}};
        };

        it 'ErrUserIdPresence、ErrUserIdInvalidともに設定されていないこと' => sub {
          my $errors = Func::Article::validate($params);

          ok(!defined($errors->{ErrUserIdPresence}));
          ok(!defined($errors->{ErrUserIdInvalid}));
        };
      };
    };

    describe 'title' => sub {
      context 'title = undefのとき' => sub {
        before each => sub {
          $params = {title => undef};
        };

        it 'ErrTitlePresenceが設定されていること' => sub {
          my $errors = Func::Article::validate($params);

          ok($errors->{ErrTitlePresence} == 1);
        };
      };

      context 'title = 256文字のとき' => sub {
        before each => sub {
          $params = {title => 'a' x 256};
        };

        it 'ErrTitlePresenceとErrTitleLengthが設定されていないこと' => sub {
          my $errors = Func::Article::validate($params);

          ok(!defined($errors->{ErrTitlePresence}));
          ok(!defined($errors->{ErrTitleLength}));
        };
      };

      context 'title = 257文字のとき' => sub {
        before each => sub {
          $params = {title => 'a' x 257};
        };

        it 'ErrTitleLengthが設定されていること' => sub {
          my $errors = Func::Article::validate($params);

          ok($errors->{ErrTitleLength} == 257);
        };
      };
    };

    describe 'body' => sub {
      context 'body = undefのとき' => sub {
        before each => sub {
          $params = {body => undef};
        };

        it 'ErrBodyPresenceが設定されていること' => sub {
          my $errors = Func::Article::validate($params);

          ok($errors->{ErrBodyPresence} == 1);
        };
      };

      context 'body = 32767文字のとき' => sub {
        before each => sub {
          $params = {body => 'a' x 3276};
        };

        it 'ErrTitlePresenceとErrTitleLengthが設定されていないこと' => sub {
          my $errors = Func::Article::validate($params);

          ok(!defined($errors->{ErrBodyPresence}));
          ok(!defined($errors->{ErrBodyLength}));
        };
      };

      context 'body = 32768文字のとき' => sub {
        before each => sub {
          $params = {body => 'a' x 32768};
        };

        it 'ErrBodyLengthが設定されていること' => sub {
          my $errors = Func::Article::validate($params);

          ok($errors->{ErrBodyLength} == 32768);
        };
      };
    };
  };

  describe 'create' => sub {
    my $params = {};
    my $user = undef;

    before each => sub {
      Func::User::create({ nickname => 'foobar', email => 'foobar@example.com', password => 'password' });
      DA::commit();
      $user = Func::User::find_by_email('foobar@example.com');
    };

    context 'validateでエラーがないとき' => sub {
      before each => sub {
        $params = {user_id => $user->{user_id}, title => 'some title', body => 'about something'};
      };

      it '登録されること' => sub {
        Func::Article::create($params);
        DA::commit();

        my $article = Func::Article::find(1);
        ok($article->{user_id} == 1);
        ok($article->{title} eq 'some title');
        ok($article->{body} eq 'about something');
      };
    };

    context 'validateでエラーがあるとき' => sub {
      before each => sub {
        $params = {user_id => $user->{user_id}, title => undef, body => 'about something'};
      };

      it '登録されないこと' => sub {
        my $ret = Func::Article::create($params);
        DA::commit();

        my $row = $dbh->selectrow_arrayref('SELECT COUNT(*) FROM articles');
        ok(!$ret);
        ok($row->[0] == 0);
      };
    };
  };

  describe 'update' => sub {
    my $params = {};
    my $author = undef;

    before each => sub {
      Func::User::create({ nickname => 'author', email => 'author@example.com', password => 'password' });
      DA::commit();
      $author = Func::User::find_by_email('author@example.com');
      Func::Article::create({user_id => $author->{user_id}, title => 'some title', body => 'about something'});
      DA::commit();
    };

    context 'validateでエラーがないとき' => sub {
      before each => sub {
        $params = {id => 1, user_id => $author->{user_id}, title => 'updated some title', body => 'updated about something'};
      };

      it '更新されること' => sub {
        Func::Article::update($params);
        DA::commit();

        my $article = Func::Article::find(1);
        ok($article->{user_id} == 1);
        ok($article->{title} eq 'updated some title');
        ok($article->{body} eq 'updated about something');
      };
    };

    context 'validateでエラーがあるとき' => sub {
      before each => sub {
        $params = {id => 1, user_id => $author->{user_id}, title => undef, body => 'updated about something'};
      };

      it '登録されないこと' => sub {
        my $ret = Func::Article::create($params);
        DA::commit();

        my $article = Func::Article::find(1);
        ok($article->{user_id} == 1);
        ok($article->{title} eq 'some title');
        ok($article->{body} eq 'about something');
      };
    };
  };

  describe 'destroy' => sub {
    my $id = undef;

    before each => sub {
      Func::User::create({ nickname => 'author', email => 'author@example.com', password => 'password' });
      DA::commit();
      my $author = Func::User::find_by_email('author@example.com');
      Func::Article::create({user_id => $author->{user_id}, title => 'some title', body => 'about something'});
      DA::commit();
    };

    context 'id = undefのとき' => sub {
      before each => sub {
        $id = undef;
      };

      it '返り値が0であること' => sub {
        my $ret = Func::Article::destroy($id);
        DA::commit();

        ok($ret == 0);
      };
    };

    context 'id = 存在するIDのとき' => sub {
      before each => sub {
        $id = 1;
      };

      it '削除されていること' => sub {
        my $ret = Func::Article::destroy($id);
        DA::commit();

        ok($ret == 1);

        my $article = Func::Article::find($id);
        ok(!defined($article));
      };
    };

    context 'id = 存在しないIDのとき' => sub {
      before each => sub {
        $id = 99999;
      };

      it '削除されていないこと' => sub {
        my $ret = Func::Article::destroy($id);
        DA::commit();

        ok($ret == 1);
        my $row = $dbh->selectrow_arrayref('SELECT COUNT(*) FROM articles');
        ok($row->[0] == 1);
      };
    };
  };
};

runtests unless caller;
