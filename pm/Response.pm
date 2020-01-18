package Response;

=pod
----------------------------------------------------------------------
HTTP レスポンスを生成
----------------------------------------------------------------------
=cut

use strict;
use MobaConf;
use HTMLFast;
use SoftbankEncode;
use Util::DoCoMoGUID;
use MLog;
use CGI;

#-----------------------------------------------------------
# html ページを返す（モバイル用）

sub output {
	my ($rHtml, $cache) = @_;
	my $html = ${$rHtml};

	# content-type は内容を見て決定
	my $charset = 'Shift_JIS';  # TODO: 自動判別にする。
	print "Content-type: text/html; charset=$charset\r\n";

	# cookieを設定
	_print_cookies($_::C);

	$html = '' if ($ENV{REQUEST_METHOD} eq 'HEAD');

	my $len = length($html);
	print "Content-length: $len\r\n";

	print "Connection: close\r\n";
	print "\r\n$html";
}

#-----------------------------------------------------------
# リダイレクト

sub redirect {
	my $url = shift;
	print "Status: 302 Found\r\n";
	print "Location: $url\r\n";
	print "Connection: close\r\n";
	_print_cookies($_::C);
	print "\r\n";
}

sub _print_cookies {
	my ($cookies) = @_;

	foreach (keys %$cookies) {
		print 'Set-Cookie:', $cookies->{$_}, "\r\n";
	}
}

1;
