package Page::Main;

=pod
----------------------------------------------------------------------
FCGI �Υᥤ��롼��
----------------------------------------------------------------------
=cut

use Time::HiRes;

use strict qw(vars subs);

use MobaConf;
use Common;
use MobileEnv;
use UserData;
use Request;
use Response;

use CGI;
use CGI::Cookie;
use CGI::Session;
use DA;
use Data::Dumper;
use HTMLTemplate;
use MException;
use MLog;

use Page::Base;

#---------------------------------------------------------------------
# �ᥤ��

sub main {
	my $t1 = Time::HiRes::time();

	#-------------------------
	# �����

	my $func = '';

	eval {
		DA::reset();
		MLog::write("$_::LOG_DIR/debug", "after DA::reset()");

		MobileEnv::set();       # ��Х����ѴĶ��ѿ�������
		$_::F = new Request();  # �ꥯ�����ȥѥ�᡼�������
		$_::U = new UserData(); # �桼����������

		$func = $_::F->{f};
		$func = $_::DEFAULT_PAGE if ($func =~ /^\./);
		$func = $_::DEFAULT_PAGE if ($func eq '');
		$func = '.404'           if (!exists($_::PAGE{$func}));

		#-------------------------------
		# Cookie����
		my %cookies = fetch CGI::Cookie;
		$_::C = \%cookies;

		#-------------------------------
		# ���å��������
		CGI::Session->name('session_id');
		my $session_id = $_::C->{session_id} ? $_::C->{session_id}->value : undef;
		$_::S = new CGI::Session("driver:File", $session_id, {Directory=>'/tmp'});
		$session_id = $_::S->id() unless (defined($session_id));
		$_::C->{session_id} = new CGI::Cookie(-name => 'session_id', -value => $session_id, -expires => '+1y');
		$_::S->expires('+1y');

		#-------------------------------
		# �����ۥ���̾������Request.pm �� make(SSL)BasePath �ǻȤ����

		$ENV{MB_REQUIRED_PROTO} = '';
		$ENV{MB_REQUIRED_HOST}  = '';

		#-------------------------------
		# ��³�������å�����

		if ($_::BYPASS_FUNC{$func} >= 2) {
			goto FUNC_START;
		}

		#-------------------------------
		# ������쥯��

		if ($_::BYPASS_FUNC{$func} >= 1) { # ������쥯�Ƚ���
			goto FUNC_START;
		}

		#-------------------------------
		# URL�����߾���

		# if ($_::U->{URL_INFO} &&
		# 	$_::U->{URL_INFO} ne $_::U->{URL_INFO_C}) {
		# 	redirectToRightDomain();
		# 	goto FUNC_END;
		# }
	};

	if ($@) {
		my $e   = MException::getInfo();
		my $msg = MException::makeMsg($e);
		eval { DA::rollback(); };
		MLog::write($_::LOG_FCGI_ERR,
			"UA:  $ENV{HTTP_USER_AGENT}\t".
			"REQ: $ENV{REQUEST_METHOD} $ENV{REQUEST_URI}\t".
			"REF: $ENV{HTTP_REFERER}\t".
			"$msg");
		Page::Base::pageError($e);
		goto FUNC_END;
	}

	#---------------------------
	# ���굡ǽ�򥳡���

FUNC_START:

	while (1) {
		MLog::write("$_::LOG_DIR/debug", "loop start");

		eval {
		  MLog::write("$_::LOG_DIR/debug", "before callPage($func)");
			callPage($func);
		  MLog::write("$_::LOG_DIR/debug", "after callPage($func)");
		};

		if ($@) {
			my $e = MException::getInfo();
			eval { DA::rollback(); };
			if ($e->{_T} eq 'ERR') {
				my $msg = MException::makeMsg($e);
				MLog::write($_::LOG_FCGI_ERR,
					"UA:  $ENV{HTTP_USER_AGENT}\t".
					"REQ: $ENV{REQUEST_METHOD} $ENV{REQUEST_URI}\t".
					"REF: $ENV{HTTP_REFERER}\t".
					"$msg");
				Page::Base::pageError($e);
				last;
			} elsif ($e->{CHG_FUNC}) { # �ե��󥯥�����ѹ�
				$func = $e->{CHG_FUNC};
				redo;
			} elsif ($e->{REDIRECT}) { # URL���������쥯��
				Response::redirect($e->{REDIRECT});
				last;
			} elsif ($e->{REDIRECT2}) { # URL �ƺ���
				redirectToRightDomain();
				last;
			}
		}
		MLog::write("$_::LOG_DIR/debug", "loop end");
		last;
	}

FUNC_END:

	DA::release();
	MLog::write("$_::LOG_DIR/debug", "after DA::release()");
}

#---------------------------------------------------------------------

sub callPage {
	my $func = shift;
	MLog::write("$_::LOG_DIR/debug", "start callPage($func)");

	#---------------------------
	# �׵ᤵ�줿�ڡ�����������

	my ($reqUidSt, $reqUserSt, $reqServSt, $moduleName, $subName)
		= @{$_::PAGE{$func}};
	MLog::write("$_::LOG_DIR/debug", "Page infomation $reqUidSt, $reqUserSt, $reqServSt, $moduleName, $subName");

	#---------------------------
	# UID_ST ü�����󥨥顼

	if ($_::U->{UID_ST} < $reqUidSt) {
		if ($ENV{MB_CARRIER_UA} eq 'D' &&
			$ENV{REQUEST_URI} !~ /[\?\&]guid=ON/) {
			MException::throw({ REDIRECT2 => 1 });
		}
		MException::throw({ CHG_FUNC => '.nouid' });
	}

	#---------------------------
	# SERV_ST �����ӥ����ơ����������å�

	if ($_::U->{SERV_ST} & $reqServSt) {
		MLog::write("$_::LOG_DIR/debug", "Error SERV_ST");
		$_::U->{SERV_ST_ERR} = $_::U->{SERV_ST} & $reqServSt;
		MException::throw({ CHG_FUNC => '.servst' });
	}

	#---------------------------
	# USER_ST �桼�����ơ����������å�

	if ($_::U->{USER_ST} < $reqUserSt) {
		MLog::write("$_::LOG_DIR/debug", "Error USER_ST");
		if ($_::U->{USER_ST} == 1) {
			# ***
			MException::throw({ CHG_FUNC => 'm01' });
		} else {
			MException::throw({ CHG_FUNC => 'welcome' });
		}
	}

	#---------------------------
	# ������

	if ($_::MAINTAIN_FUNC{$func}) {
		MLog::write("$_::LOG_DIR/debug", "Error Maintenance");
		MException::throw({ REDIRECT =>
			Request::makeBasePath(). $_::MAINTAIN_FUNC{$func} });
	}

	#---------------------------
	# �ڡ����̵�ǽ�򥳡���

	my $moduleFile = "$moduleName.pm";
	   $moduleFile =~ s#::#/#g;
	MLog::write("$_::LOG_DIR/debug", "before require $moduleFile");
	require $moduleFile;
	&{"$moduleName\::$subName"}($func);
}

#---------------------------------------------------------------------
# UA �����𤷤�����ꥢ̾��Ŭ�����ɥᥤ��˥�����쥯��
# URL�����߾���⿷������Τ˥��å�

sub redirectToRightDomain {
	if ($ENV{REQUEST_METHOD} eq 'POST') {
		Page::Base::pageRedirect();
		return;
	}
	my $url;
	if ($ENV{MB_CARRIER_UA} eq '-') {
		$url = "http://$_::PC_HOST/";
	} else {
		if (($ENV{MB_REQUIRED_PROTO} ne 'http' && $ENV{MB_SSL}) ||
			($ENV{MB_REQUIRED_PROTO} eq 'https')) {
			$url = Request::makeSSLBasePath();
		} else {
			$url = Request::makeBasePath();
		}

		my $tmp = $ENV{REQUEST_URI};
		$tmp = "/$'" if ($tmp =~ m#/\.[^/]*/#);
		$url .= $tmp;

		if ($ENV{MB_CARRIER_UA} eq 'D' &&
			$url !~ /[\&\?]guid=ON/i) {
			$url .= ($url =~ /\?/ ? '&' : '?'). "guid=ON";
		}
	}

	Response::redirect($url);
}

1;
