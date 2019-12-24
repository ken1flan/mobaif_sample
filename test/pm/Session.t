use strict;
use utf8;

use MobaConf;
use Test::Spec;

use Session;

use CGI::Session;
use Func::User;

use Text::Password::SHA;

describe 'Session' => sub {
  my $dbh = DA::getHandle($_::DB_USER_W);
  after each => sub {
    $dbh->do('TRUNCATE TABLE user_data;');
  };

  describe 'create' => sub {
    context 'email = foobar@example.com, password = passwordであるユーザが存在するとき' => sub {
      before each => sub {
        Func::User::create({ nickname => 'foobar', email => 'foobar@example.com', password => 'password' });
        DA::commit();

        $_::S = new CGI::Session("driver:File", undef, {Directory=> $_::SESSION_DIR})
      };

      context 'email = f00@example.com のとき' => sub {
        my $email = 'f00@example.com';

        context 'password = password のとき' => sub {
          my $password = 'password';

          it 'falseになること' => sub {
            my $ret = Session::create($email, $password);
            ok(!$ret);
          };
        };
      };

      context 'email = foobar@example.com のとき' => sub {
        my $email = 'foobar@example.com';

        context 'password = passw0rd のとき' => sub {
          my $password = 'passw0rd';

          it 'falseになること' => sub {
            my $ret = Session::create($email, $password);
            ok(!$ret);
          };
        };

        context 'password = password のとき' => sub {
          my $password = 'password';

          it 'trueになること' => sub {
            my $pwd = Text::Password::SHA->new();
            my $ret = Session::create($email, $password);
            ok($ret == 1);
          };
        };
      };
    };
  };

  describe 'destroy' => sub {
    before each => sub {
      $_::S = new CGI::Session("driver:File", undef, {Directory=> $_::SESSION_DIR});
    };

    context 'sessionにuser_idが保存されていないとき' => sub {
      it 'パラメータからuser_idが削除されていること' => sub {
        Session::destroy();
        ok(!defined($_::S->param('user_id')));
      };
    };

    context 'sessionにuser_idが保存されているとき' => sub {
      before each => sub {
        $_::S->param('user_id', 1);
      };

      it 'パラメータからuser_idが削除されていること' => sub {
        Session::destroy();
        ok(!defined($_::S->param('user_id')));
      };
    };
  };
};

runtests unless caller;
