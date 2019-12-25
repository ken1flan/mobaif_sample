use Test::Spec;

use MobaConf;
use Test::Spec;
use Data::Dumper;

use UserData;

use CGI::Session;
use DA;
use Func::User;

describe 'UserData' => sub {
  describe 'getInfo' => sub {
    my $dbh = DA::getHandle($_::DB_USER_W);
    my $user;

    before all => sub {
      Func::User::create({ nickname => 'foobar', email => 'foobar@example.com', password => 'password' });
      DA::commit();

      $user = Func::User::find_by_email('foobar@example.com');
    };

    after all => sub {
      $dbh->do('TRUNCATE TABLE user_data;');
    };

    before each => sub {
      $_::S = new CGI::Session("driver:File", undef, {Directory=> $_::SESSION_DIR});
    };

    context 'セッションにuser_idが保存されていないとき' => sub {
      it 'ユーザ情報が空であること' => sub {
        my $user_data = new UserData();
        $user_data->getInfo();

        ok(!defined($user_data->{USER_ID}));
      };
    };

    context 'セッションに登録されていないuser_idが保存されているとき' => sub {
      before each => sub {
        $_::S->param('user_id', 99999);
      };

      it 'ユーザ情報が空であること' => sub {
        my $user_data = new UserData();
        $user_data->getInfo();

        ok(!defined($user_data->{USER_ID}));
      };
    };

    context 'セッションに登録されているuser_idが保存されているとき' => sub {
      before each => sub {
        $_::S->param('user_id', $user->{user_id});
      };

      it 'ユーザ情報が格納されていること' => sub {
        my $user_data = new UserData();
        $user_data->getInfo();

        ok($user_data->{USER_ID} == $user->{user_id});
      };
    };
  };
};

runtests unless caller;
