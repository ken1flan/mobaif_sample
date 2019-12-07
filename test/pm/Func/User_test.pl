use MobaConf;
use Func::User;

use Test::Spec;

describe 'Func::User' => sub {
  describe 'validate' => sub {
    describe 'nickname' => sub {
      context 'undefのとき' => sub {
        my $params = { };

        it 'ErrNicknamePresenceが設定されていること' => sub {
          my $err = Func::User::validate($params);
            ok($err->{ErrNicknamePresence} == 1);
        };
      }

      context '空文字列のとき' => sub {
        my $params = { nickname => '' };

        it 'ErrNicknamePresenceが設定されていること' => sub {
          my $err = Func::User::validate($params);
            ok($err->{ErrNicknamePresence} == 1);
        };
      }

      context '21文字のとき' => sub {
        my $params = { nickname => '１２３４５６７８９０１２３４５６７８９０１' };

        it 'ErrNicknameLengthが設定されていること' => sub {
          my $err = Func::User::validate($params);
            ok($err->{ErrNicknameLength} == 21);
        };
      }
    }
  }
};

runtests unless caller;
