use strict;
use utf8;

use MobaConf;
use Test::Spec;
use Test::Trap;
use Response;

use CGI::Cookie;
use Data::Dumper;

describe 'Response' => sub {
  describe 'output' => sub {
    context '$_::C = undefのとき' => sub {
      it '$htmlを含むレスポンスが出力されること' => sub {
        my $html = "text";
        my $length = length($html);
        trap { Response::output(\$html) };
        my $stdout = $trap->stdout;
        ok($stdout =~ /Content-length: $length/);
        ok($stdout =~ /Content-type: text\/html; charset=Shift_JIS/);
        ok($stdout =~ /Connection: close/);
        ok($stdout =~ /$html/);
      };
    };

    context '$_::C = {foo => {name => "foo", value => "bar"}}のとき' => sub {
      it '$htmlと$_::Cの内容を含むレスポンスが出力されること' => sub {
        $_::C = { foo => new CGI::Cookie(-name => 'foo', -value => 'bar')};

        my $html = "text";
        my $length = length($html);
        trap { Response::output(\$html) };
        my $stdout = $trap->stdout;
        ok($stdout =~ /Content-length: $length/);
        ok($stdout =~ /Content-type: text\/html; charset=Shift_JIS/);
        ok($stdout =~ /Set-Cookie:foo=bar; path=\//);
        ok($stdout =~ /Connection: close/);
        ok($stdout =~ /$html/);
      };
    };
  };

  describe 'redirect' => sub {
    context '$_::C = undefのとき' => sub {
      it '$urlを含むレスポンスが出力されること' => sub {
        my $url = "https://www.example.com/user/new";
        trap { Response::redirect($url) };
        my $stdout = $trap->stdout;
        ok($stdout =~ /Location: $url/);
        ok($stdout =~ /Connection: close/);
      };
    };

    context '$_::C = {foo => {name => "foo", value => "bar"}}のとき' => sub {
      it '$urlと$_::Cの内容を含むレスポンスが出力されること' => sub {
        $_::C = {foo => new CGI::Cookie(-name => 'foo', -value => 'bar')};

        my $url = "https://www.example.com/user/new";
        trap { Response::redirect($url) };
        my $stdout = $trap->stdout;
        ok($stdout =~ /Location: $url/);
        ok($stdout =~ /Set-Cookie:foo=bar; path=\//);
        ok($stdout =~ /Connection: close/);
      };
    };
  };

  describe '_print_cookies' => sub {
    context '$cookies = undefのとき' => sub {
      it 'なにも出力されないこと' => sub {
        my $cookies = undef;
        trap { Response::_print_cookies($cookies) };
        my $stdout = $trap->stdout;
        ok($stdout eq '');
      };
    };

    context '$cookies = {}のとき' => sub {
      it 'なにも出力されないこと' => sub {
        my $cookies = {};
        trap { Response::_print_cookies($cookies) };
        my $stdout = $trap->stdout;
        ok($stdout eq '');
      };
    };

    context '$cookies = { foo => {name => "foo", value => "bar"}}のとき' => sub {
      it 'foo=barが出力されること' => sub {
        my $cookies = {foo => new CGI::Cookie(-name => 'foo', -value => 'bar')};

        trap { Response::_print_cookies($cookies) };
        my $stdout = $trap->stdout;
        ok($stdout =~ /Set-Cookie:foo=bar; path=\//);
      };
    };

    context '$cookies = { foo1 => {name => "foo1", value => "bar1"}, foo2 => {name => "foo2", value => "bar2"}}のとき' => sub {
      it 'foo1=bar1とfoo2=bar2が出力されること' => sub {
        my $cookies = {
          foo1 => new CGI::Cookie(-name => 'foo1', -value => 'bar1'),
          foo2 => new CGI::Cookie(-name => 'foo2', -value => 'bar2')
        };

        trap { Response::_print_cookies($cookies) };
        my $stdout = $trap->stdout;
        ok($stdout =~ /Set-Cookie:foo1=bar1; path=\//);
        ok($stdout =~ /Set-Cookie:foo2=bar2; path=\//);
      };
    };
  };
};

runtests unless caller;
