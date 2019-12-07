package Func::User;

use strict;
use MobaConf;
use Kcode;
use Common;

our $NICKNAME_MIN_LENGTH = 5;
our $NICKNAME_MAX_LENGTH = 20;
our $EMAIL_MAX_LENGTH = 256;
our $INTRODUCTION_MAX_LENGTH = 256;

#-----------------------------------------------------------
# 利用機種の更新

sub updateModel {
	my ($user_id, $model_name) = @_;

	my $dbh = DA::getHandle($_::DB_USER_W);
	my $sth = $dbh->prepare(<<'SQL');
	update user_data set model_name=? where user_id=?
SQL
	$sth->execute($model_name, $user_id);
}

#-----------------------------------------------------------
# プロフィール表示項目のデータ生成

sub makeProfile {
	my ($rhData) = @_;

	if ($rhData->{birthday} =~ /^(\d+)-(\d+)-(\d+)$/ ||
	    $rhData->{birthday} =~ /^(\d{4})(\d\d)(\d\d)$/) {
		my @t1 = (localtime())[5,4,3]; $t1[0] += 1900; $t1[1]++;
		my @t2 = ($1, $2, $3);
		$rhData->{Birthday} = Kcode::e2s(sprintf("%d月%d日", @t2[1, 2]));
		$rhData->{Age} = ($t1[0] - $t2[0]) -
			(($t1[1] * 100 + $t1[2] < $t2[1] * 100 + $t2[2]) ? 1 : 0);
	}
}

#-----------------------------------------------------------
# ハッシュ参照、もしくはハッシュ参照のリストに、ユーザ情報を追加する
#
# $data : ハッシュ参照 or ハッシュ参照のリスト
# $key  : $data のハッシュ参照で、ユーザIDをあらわすキー名
# $rows : user_data に対する select 文の対象カラム部分

sub addUserInfo {
	my ($data, $key, $rows) = @_;

	my $rList = [];
	if (ref($data) eq 'HASH') {
		push(@{$rList}, $data);
	} elsif (ref($data) eq 'ARRAY') {
		$rList = $data;
	} else {
		return;
	}

	my @user_ids;
	for my $rHash (@{$rList}) {
		if (ref($rHash) eq 'HASH' &&
		    exists($rHash->{$key})) {
			push(@user_ids, int($rHash->{$key}));
		}
	}

	my $ids = join(',', 0, @user_ids);

	my $dbh = DA::getHandle($_::DB_USER_R);
	my $ret = $dbh->selectall_hashref(<<"SQL", '_u');
	select user_id _u, $rows from user_data where user_id in ($ids);
SQL
	for my $rHash (@{$rList}) {
		if (ref($rHash) eq 'HASH' &&
		    exists($rHash->{$key}) &&
			exists($ret->{$rHash->{$key}})) {

			Common::mergeHash($rHash, $ret->{$rHash->{$key}}, '^[^_]');
		}
	}
}

sub validate {
	my ($params) = @_;
	my $errors = {};

	my $emailErrors = _validateEmail($params->{email});
	Common::mergeHash($errors, $emailErrors);
	my $nicknameErrors = _validateNickname($params->{nickname});
	Common::mergeHash($errors, $nicknameErrors);
	my $introductionErrors = _validateIntroduction($params->{introduction});
	Common::mergeHash($errors, $introductionErrors);

	return $errors;
}

sub _validateEmail {
	my ($email) = @_;
	my $errors = {};

	if (!defined($email) || $email eq '') {
		$errors->{ErrEmailPresence} = 1;
		return $errors;
	}

	my $len = length($email);
	if ($len > $EMAIL_MAX_LENGTH) {
		$errors->{ErrEmailLength} = $len;
		return $errors;
	}

	unless ($email =~ /\A.+@.+\z/) {
		$errors->{ErrEmailFormat} = 1;
		return $errors;
	}

	my $dbh = DA::getHandle($_::DB_USER_R);
	my @row = $dbh->selectrow_array("SELECT COUNT(*) FROM user_data WHERE email = ?", undef, ($email));
	$errors->{ErrEmailUnique} = 1 if $row[0] > 0;

	return $errors;
}

sub _validateNickname {
	my ($nickname) = @_;
	my $errors = {};

	if (!defined($nickname) || $nickname eq '') {
		$errors->{ErrNicknamePresence} = 1;
		return $errors;
	}
	my $len = length($nickname);
	if ($len < $NICKNAME_MIN_LENGTH || $len > $NICKNAME_MAX_LENGTH) {
		$errors->{ErrNicknameLength} = $len;
		return $errors;
	}

	my $dbh = DA::getHandle($_::DB_USER_R);
	my @row = $dbh->selectrow_array("SELECT COUNT(*) FROM user_data WHERE nickname = ?", undef, ($nickname));
	$errors->{ErrNicknameUnique} = 1 if $row[0] > 0;

	return $errors;
}

sub _validateIntroduction {
	my ($introduction) = @_;
	my $errors = {};

	if (!defined($introduction) || $introduction eq '') {
		return $errors;
	}

	my $len = length($introduction);
	if ($len > $INTRODUCTION_MAX_LENGTH) {
		$errors->{ErrIntroductionLength} = $len;
		return $errors;
	}

	return $errors;
}

1;
