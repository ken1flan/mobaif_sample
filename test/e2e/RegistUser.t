use strict;
use warnings;
use utf8;

use Log::Log4perl qw(:easy);
use WWW::Mechanize::Chrome;
use Test::Spec;

use MobaConf;
use DA;

describe 'Regist user' => sub {
  my $mech;

  before each => sub {
    $mech = WWW::Mechanize::Chrome->new(headless=> 1);
    $mech->get('http://127.0.0.1/user/new');
  };

  after each => sub {
    my $dbh = DA::getHandle($_::DB_USER_W);
    $dbh->do('TRUNCATE TABLE user_data;');
  };

  context 'ユーザ登録ページを訪れたとき' => sub {
    it 'フォームが表示されていること' => sub {
      my $content = $mech->content;
      ok( $content =~ /会員登録フォーム/ );
    };

    context '内容に不備があったとき' => sub {
      before each => sub {
        my $content = $mech->content;
        $mech->click('regist');
      };

      it 'エラーが表示され、登録できないこと' => sub {
        my $content = $mech->content;
        ok( $content =~ /会員登録フォーム/ );
        ok( $content =~ /エラーがあります/ );
      };

      context '内容の不備を解消したとき' => sub {
        before each => sub {
          $mech->set_fields(
            nickname => 'ニック1',
            email => 'nick1@example.com',
            password => 'password'
          );
          $mech->click('regist');
        };

        it '登録が完了できること' => sub {
          my $content = $mech->content;
          ok( $content =~ /会員登録が完了しました/ );
        };
      };
    };

    context '内容に不備がなかったとき' => sub {
      before each => sub {
        $mech->set_fields(
          nickname => 'ニック1',
          email => 'nick1@example.com',
          password => 'password'
        );
        $mech->click('regist');
      };

      it '登録が完了できること' => sub {
        my $content = $mech->content;
        ok( $content =~ /会員登録が完了しました/ );
      };

      context 'もう一度ニックネームで登録しようとしたとき' => sub {
        before each => sub {
          $mech = WWW::Mechanize::Chrome->new(headless=> 1);
          $mech->get('http://127.0.0.1/user/new');
          $mech->set_fields(
            nickname => 'ニック1',
            email => 'nick2@example.com',
            password => 'password'
          );
          $mech->click('regist');
        };

        it 'エラーが表示され、登録できないこと' => sub {
          my $content = $mech->content;
          ok( $content =~ /会員登録フォーム/ );
          ok( $content =~ /エラーがあります/ );
          ok( $content =~ /そのニックネームは他の方に使われています/ );
        };
      };
    };
  };
};

runtests unless caller;
