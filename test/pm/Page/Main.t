# use strict qw(vars subs);
use strict;
use utf8;

use MobaConf;
use Test::Spec;
use Page::Main;

use CGI::Cookie;
use CGI::Session;
use Data::Dumper;

describe 'Page::Main' => sub {
  describe '_restore_or_create_session' => sub {
    before each => sub {
      $_::C = {};
      $_::S = undef;
      unlink(glob($_::SESSION_DIR.'/*'));
    };

    context 'session_idが保存されていないとき' => sub {
      it 'セッションが作成されていること' => sub {
        Page::Main::_restore_or_create_session();
        ok($_::C->{session_id}->value eq $_::S->id());
      };
    };

    context 'session_idが保存されているとき' => sub {
      context 'セッションが作成済みのとき' => sub {
        it 'セッションが作成されていること' => sub {
          Page::Main::_restore_or_create_session();
          my $old_session_id = $_::S->id();
          $_::S->close(); # セッションファイルに書き込みを強制する
          Page::Main::_restore_or_create_session();
          ok($old_session_id eq $_::S->id());
          ok($_::C->{session_id}->value eq $_::S->id());
        };
      };
    };
  };
};

runtests unless caller;
