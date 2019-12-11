use strict;
use utf8;

use MobaConf;
use Test::Spec;
use Func::User;
use DA;

use Data::Dumper;

describe 'Func::User' => sub {
  my $dbh = DA::getHandle($_::DB_USER_W);
  after each => sub {
    $dbh->do('TRUNCATE TABLE user_data;');
  };

  describe 'validate' => sub {
    describe 'email' => sub {
      context 'undefのとき' => sub {
        my $params = {};

        it 'ErrEmailPresenceが設定されていること' => sub {
          my $err = Func::User::validate($params);
          ok($err->{ErrEmailPresence} == 1);
        };
      };

      context '空文字列のとき' => sub {
        my $params = { email => '' };

        it 'ErrEmailPresenceが設定されていること' => sub {
          my $err = Func::User::validate($params);
          ok($err->{ErrEmailPresence} == 1);
        };
      };

      context '257文字のとき' => sub {
        my $params = { email => 'a' x 257 };

        it 'ErrEmailLengthが設定されていること' => sub {
          my $err = Func::User::validate($params);
          ok($err->{ErrEmailLength} == 257);
        };
      };

      context 'Emailの形式でないとき' => sub {
        my $params = { email => 'foobar＠example.com' };

        it 'ErrEmailFormatが設定されていること' => sub {
          my $err = Func::User::validate($params);
          ok($err->{ErrEmailFormat} == 1);
        };
      };

      context 'emailがfoobar@example.comであるuser_dataが存在するとき' => sub {
        before each => sub {
          $dbh->do("
            INSERT INTO user_data(reg_date, user_st, serv_st, carrier, model_name, email, nickname)
            VALUES(UNIX_TIMESTAMP(), 0, 0, 'D', 'SOMETHING', 'foobar\@example.com', 'foobar');
          ");
          $dbh->do("COMMIT");
        };

        context 'emailがfoobar@example.comのとき' => sub {
          my $params = { email => 'foobar@example.com' };

          it 'ErrEmailUniqueが設定されていること' => sub {
            my $err = Func::User::validate($params);
            ok($err->{ErrEmailUnique} == 1);
          };
        };

        context 'emailがfoobar2@example.comのとき' => sub {
          my $params = { email => 'foobar2@example.com' };

          it 'ErrEmailUniqueが設定されていないこと' => sub {
            my $err = Func::User::validate($params);
            ok(!defined($err->{ErrEmailUnique}));
          };
        };
      };
    };

    describe 'nickname' => sub {
      context 'undefのとき' => sub {
        my $params = {};

        it 'ErrNicknamePresenceが設定されていること' => sub {
          my $err = Func::User::validate($params);
          ok($err->{ErrNicknamePresence} == 1);
        };
      };

      context '空文字列のとき' => sub {
        my $params = { nickname => '' };

        it 'ErrNicknamePresenceが設定されていること' => sub {
          my $err = Func::User::validate($params);
          ok($err->{ErrNicknamePresence} == 1);
        };
      };

      context '4文字のとき' => sub {
        my $params = { nickname => '１２３４' };

        it 'ErrNicknameLengthが設定されていること' => sub {
          my $err = Func::User::validate($params);
          ok($err->{ErrNicknameLength} == 4);
        };
      };

      context '21文字のとき' => sub {
        my $params = { nickname => '１２３４５６７８９０１２３４５６７８９０１' };

        it 'ErrNicknameLengthが設定されていること' => sub {
          my $err = Func::User::validate($params);
          ok($err->{ErrNicknameLength} == 21);
        };
      };

      context 'nicknameがfoobarであるuser_dataが存在するとき' => sub {

        before each => sub {
          $dbh->do("
            INSERT INTO user_data(reg_date, user_st, serv_st, carrier, model_name, email, nickname)
            VALUES(UNIX_TIMESTAMP(), 0, 0, 'D', 'SOMETHING', 'foobar\@example.com', 'foobar');
          ");
          $dbh->do("COMMIT");
        };

        context 'nicknameがfoobarのとき' => sub {
          my $params = { nickname => 'foobar' };

          it 'ErrNicknameUniqueが設定されていること' => sub {
            my $err = Func::User::validate($params);
            ok($err->{ErrNicknameUnique} == 1);
          };
        };

        context 'nicknameがfoobar2のとき' => sub {
          my $params = { nickname => 'foobar2' };

          it 'ErrNicknameUniqueが設定されていないこと' => sub {
            my $err = Func::User::validate($params);
            ok(!defined($err->{ErrNicknameUnique}));
          };
        };
      };
    };

    describe 'introduction' => sub {
      context '256文字のとき' => sub {
        my $params = { introduction => 'a' x 256 };

        it 'ErrIntroductionLengthが設定されていないこと' => sub {
          my $err = Func::User::validate($params);
          ok(!defined($err->{ErrIntroductionLength}));
        };
      };

      context '257文字のとき' => sub {
        my $params = { introduction => 'a' x 257 };

        it 'ErrIntroductionLengthが設定されていること' => sub {
          my $err = Func::User::validate($params);
          ok($err->{ErrIntroductionLength} == 257);
        };
      };
    };
  };

  describe 'create' => sub {
    context 'validateでエラーがないとき' => sub {
      my $params = { email => 'foobar@example.com', nickname => 'foobar' };

      it '登録されること' => sub {
        my $ret = Func::User::create($params);
        my $row = $dbh->selectrow_hashref('SELECT * FROM user_data');
        ok($ret);
        ok($row->{email} eq $params->{email});
        ok($row->{nickname} eq $params->{nickname});
      };
    };

    context 'validateでエラーがあるとき' => sub {
      my $params = {};

      it '登録されないこと' => sub {
        my $ret = Func::User::create($params);
        my $row = $dbh->selectrow_arrayref('SELECT COUNT(*) FROM user_data');
        ok(!$ret);
        ok($row->[0] == 0);
      };
    };
  };
};

runtests unless caller;
