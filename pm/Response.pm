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

#-----------------------------------------------------------
# html ページを返す（モバイル用）

sub output {
	my ($rHtml, $cache) = @_;
	my $html = ${$rHtml};
	MLog::write("$_::LOG_DIR/debug", "Response::ouput() start");

	# content-type は内容を見て決定
	my $charset = 'Shift_JIS';  # TODO: 自動判別にする。
	print "Content-type: text/html; charset=$charset\r\n";

	$html = '' if ($ENV{REQUEST_METHOD} eq 'HEAD');

	my $len = length($html);
	print "Content-length: $len\r\n";

	print "Connection: close\r\n";
	print "\r\n$html";
	MLog::write("$_::LOG_DIR/debug", "Response::ouput() end");
}

#-----------------------------------------------------------
# リダイレクト

sub redirect {
	my $url = shift;
	print "Location: $url\r\n";
	print "Connection: close\r\n";
	print "\r\n";
}

1;
