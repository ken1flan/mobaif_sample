package UserData;

=pod
----------------------------------------------------------------------
�桼����������⥸�塼��

���ꥯ��������ˡ�uid �ʤɤ򥭡��ˡ��桼���������� DB ����������롣
_getInfo ����Ǽ������륫���ϡ������ӥ���ɬ�פ˱������ѹ����뤳�ȡ�
�桼��ǧ�ڤˤɤΤ褦���������Ѥ��뤫�ϥ����ӥ��ˤ�äưۤʤ롣
----------------------------------------------------------------------
=cut

use strict;
use MobaConf;

use Func::User;

# new ������ MobileEnv::set() �μ¹Ԥ�ɬ��

sub new {
	my ($pkg) = @_;
	my $self = {};
	bless($self, $pkg);

	# UID_ST: UID�������ơ�����
	#   0:����ʤ� 3:serial/uid ����
	# �ʢ����ơ������μ���ϥ����ӥ������

	$self->{UID_ST}  = 0;

	# USER_ST: �����Ͽ���ơ�����
	#   0:���� 1:����ʥᥢ��̤ǧ�ڡ� 2:����ʥᥢ��ǧ�ںѡ�
	# �ʢ����ơ������μ���ϥ����ӥ������

	$self->{USER_ST} = 0;

	# SERV_ST: �����ӥ����ѥ��ơ����� (�ʲ���­�������)
	#  1:������� 2:�������
	#  4:�ڥʥ�ƥ��� 8:�᡼����ã������ǽ
	# �ʢ����ơ������μ���ϥ����ӥ������

	$self->{SERV_ST} = 0;

	if ($_::F->{_u}) {

		# http://host/.*****/ �� ***** ����ʬ�� _u �����롣
		# �Ȥ����ϥ����ӥ����衣�ƥ�ץ쥳��ѥ�������Хѥ���
		# ���ܤ���褦�ˤ��Ƥ���Τ� _u �ξ���Ͼä��ʤ���

		$self->{URL_INFO_C} = $self->{URL_INFO} = $_::F->{_u};

		# URL_INFO_C : URL ���Ϥ��줿����
		# URL_INFO   : URL ���Ϥ�����

		# URL_INFO_C ne URL_INFO �ˤʤ�ȡ�
		# URL �˥ǡ������������URL�˼�ư������쥯�Ȥ���롣

		# docomo �� SSL ���ܤʤɤǻ��Ѥ���Τ���
	}

	$self->getInfo() if (!$_::BYPASS_FUNC{$_::F->{f}});

	return($self);
}

#--------------------------------------------------------
# �����ݻ�ʸ���������

sub makeInfoStr {
	my $self = shift;

	if ($self->{URL_INFO}) {
		return "/.". $self->{URL_INFO};
	}
}

#=====================================================================
#                        �桼������μ���
#=====================================================================

sub getInfo {
	my ($self) = @_;

	my $user_id = $_::S->param('user_id');
	return undef unless defined($user_id);

	my $user = Func::User::find($user_id);
	return undef unless defined($user);

	$self->{USER_ID} = $user->{user_id};
	$self->{NICKNAME} = $user->{nickname};
	$self->{USER_ST} = $user->{user_st};
	$self->{SERV_ST} = $user->{serv_st};
	$self->{REG_MODEL} = $user->{model_name};

	return undef;
};

1;

