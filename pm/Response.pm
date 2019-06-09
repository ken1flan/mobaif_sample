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
	MLog::write("$_::LOG_DIR/debug", "Response::ouput() start");

	my $charset = 'Shift_JIS';

	# content-type �����Ƥ򸫤Ʒ���

	my $head = substr($html, 0, 100);
	if ($head =~ /<\?\s*xml/) {
		if ($ENV{MB_CARRIER_IP} eq 'I') {

			# ����ʤɤ����̾�Υ֥饦���Ǹ�����ˡ�
			# content-type �� xhtml �Ȥ����֤���ɽ��������뤿�ᡣ

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

	# FOMA �Ǥϡ�no-cache ����ꤹ��ȡ��֥饦���Хå��ξ��Ǥ�
	# ���ɤ߹��ߤ����Τǡ����Τ褦�ʵ�ư�ˤ��Ƥ��롣

	# au �ϥ���å��夬�����Τǡ�ɬ�� no-cache ���դ��롣
	# no-cache ���դ��Ƥ⡢�ʤࡿ���Ǥϥ���å��夷��
	# �ڡ������Ȥ���ΤǤ������ʤ���

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
# ������쥯��

sub redirect {
	my $url = shift;
	print "Location: $url\r\n";
	print "Connection: close\r\n";
	print "\r\n";
}

1;
