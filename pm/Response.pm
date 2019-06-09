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
	MLog::write("$_::LOG_DIR/debug", "Response::ouput() start");

	my $charset = 'Shift_JIS';

	# content-type は内容を見て決定

	my $head = substr($html, 0, 100);
	if ($head =~ /<\?\s*xml/) {
		if ($ENV{MB_CARRIER_IP} eq 'I') {

			# 社内などから通常のブラウザで見る場合に、
			# content-type を xhtml として返すと表示が崩れるため。

			print "Content-type: text/html; charset=$charset\r\n";
		} else {
			print "Content-type: application/xhtml+xml; charset=$charset\r\n";
		}
	} else {
		print "Content-type: text/html; charset=$charset\r\n";
	}

	$html = '' if ($ENV{REQUEST_METHOD} eq 'HEAD');

	my $len = length($html);
	print "Content-length: $len\r\n";

	# FOMA では、no-cache を指定すると、ブラウザバックの場合でも
	# 再読み込みされるので、このような挙動にしている。

	# au はキャッシュが強いので、必ず no-cache を付ける。
	# no-cache を付けても、進む／戻るではキャッシュした
	# ページが使われるのでうざくない。

	my $nocache =
		($cache eq 'no-cache') ? 1 :
		($cache eq 'cache')    ? 0 :
		($ENV{REQUEST_METHOD} eq 'POST') ? 0 :
		($ENV{MB_MODEL_TYPE}  eq 'DF'  ) ? 0 : 1;

	if ($nocache) {
		print "Cache-control: no-cache\r\n";
		print "Pragma: no-cache\r\n";
	}

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
