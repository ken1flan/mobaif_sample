package Response;

=pod
----------------------------------------------------------------------
HTTP �쥹�ݥ󥹤�����
----------------------------------------------------------------------
=cut

use strict;
use MobaConf;
use HTMLFast;
use SoftbankEncode;
use Util::DoCoMoGUID;

#-----------------------------------------------------------
# html �ڡ������֤��ʥ�Х����ѡ�

sub output {
	my ($rHtml, $cache) = @_;
	my $html = ${$rHtml};
	MLog::write("$_::LOG_DIR/debug", "Response::ouput() start");

	# content-type �����Ƥ򸫤Ʒ���
	my $charset = 'Shift_JIS';  # TODO: ��ưȽ�̤ˤ��롣
	print "Content-type: text/html; charset=$charset\r\n";

	$html = '' if ($ENV{REQUEST_METHOD} eq 'HEAD');

	my $len = length($html);
	print "Content-length: $len\r\n";

	print "Connection: close\r\n";
	print "\r\n$html";
	MLog::write("$_::LOG_DIR/debug", "Response::ouput() end");
}

#-----------------------------------------------------------
# ������쥯��

sub redirect {
	my $url = shift;
	print "Location: $url\r\n";
	print "Connection: close\r\n";
	print "\r\n";
}

1;
