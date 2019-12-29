use strict;
use utf8;

use MobaConf;
use Test::Spec;

use Flash;

use CGI::Session;
use Encode;

describe 'Flash' => sub {
  before each => sub {
    $_::S = new CGI::Session("driver:File", undef, {Directory=> $_::SESSION_DIR})
  };

  describe 'set' => sub {
    my $message;
    my $type;

    context 'message = undef のとき' => sub {
      before each => sub {
        $message = undef;
      };

      context 'type = undef のとき' => sub {
        before each => sub {
          $type = undef;
        };

        it 'flash_message、flash_typeともに設定されていないこと' => sub {
          Flash::set($message, $type);

          ok(!defined($_::S->param('flash_message')));
          ok(!defined($_::S->param('flash_type')));
        };
      };

      context 'type = success' => sub {
        before each => sub {
          $type = 'success';
        };

        it 'flash_type = success と設定されていること' => sub {
          Flash::set($message, $type);

          ok(!defined($_::S->param('flash_message')));
          ok($_::S->param('flash_type') eq 'success');
        };
      };
    };

    context 'message = abc のとき' => sub {
      before each => sub {
        $message = 'abc';
      };

      context 'type = undef のとき' => sub {
        before each => sub {
          $type = undef;
        };

        it 'flash_message = abc と設定されていること' => sub {
          Flash::set($message, $type);

          ok($_::S->param('flash_message') eq 'abc');
          ok(!defined($_::S->param('flash_type')));
        };
      };

      context 'type = alert のとき' => sub {
        before each => sub {
          $type = 'alert';
        };

        it 'flash_message = abc、flash_type = alert と設定されていること' => sub {
          Flash::set($message, $type);

          ok($_::S->param('flash_message') eq 'abc');
          ok($_::S->param('flash_type') eq 'alert');
        };
      };
    };

    context 'message = あいう(euc-jp) のとき' => sub {
      before each => sub {
        $message = Encode::encode('euc-jp', 'あいう');
      };

      context 'type = notice のとき' => sub {
        before each => sub {
          $type = 'notice';
        };

        it 'flash_message = あいう(shiftjis) と設定されていること' => sub {
          Flash::set($message, $type);

          ok($_::S->param('flash_message') eq Encode::encode('shiftjis', 'あいう'));
        };
      };
    };
  };

  describe 'get' => sub {
    context 'flashが設定されていないとき' => sub {
      it 'undefが取得されること' => sub {
        my ($message, $type) = Flash::get();

        ok(!defined($message));
        ok(!defined($type));
      };
    };

    context 'flashが設定されているとき' => sub {
      before each => sub {
        Flash::set('this is message', 'warn');
      };

      it '設定した内容が取得されること' => sub {
        my ($message, $type) = Flash::get();

        ok($message eq 'this is message');
        ok($type eq 'warn');
      };
    };
  };

  describe 'clear' => sub {
    context 'flashが設定されていないとき' => sub {
      it 'undefになっていること' => sub {
        Flash::clear();

        my ($message, $type) = Flash::get();
        ok(!defined($message));
        ok(!defined($type));
      };
    };

    context 'flashが設定されているとき' => sub {
      before each => sub {
        Flash::set('this is message', 'warn');
      };

      it 'undefになっていること' => sub {
        Flash::clear();

        my ($message, $type) = Flash::get();
        ok(!defined($message));
        ok(!defined($type));
      };
    };
  };
};

runtests unless caller;
