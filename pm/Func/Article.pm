package Func::Article;

use strict;

use MobaConf;

use Common;
use DA;
use Func::User;

our $TITLE_MAX_LENGTH = 256;
our $BODY_MAX_LENGTH = 32767;

sub find {
  my ($id) = @_;

	my $dbh = DA::getHandle($_::DB_USER_R);
	my $row = $dbh->selectrow_hashref("SELECT * FROM articles WHERE id = ?", undef, ($id));
	return $row;
}

sub find_last_by_user_id {
  my ($user_id) = @_;

	my $dbh = DA::getHandle($_::DB_USER_R);
	my $row = $dbh->selectrow_hashref("SELECT * FROM articles WHERE user_id = ? ORDER BY updated_at DESC, id DESC LIMIT 1", undef, ($user_id));
	return $row;
}

sub search_by_user_id {
  my ($user_id) = @_;

	my $dbh = DA::getHandle($_::DB_USER_R);
	my $rows = $dbh->selectall_arrayref("SELECT * FROM articles WHERE user_id = ?", {Columns=>{}}, ($user_id));

	return $rows;
}

sub validate {
  my ($params) = @_;
	my $errors = {};

	my $userIdErrors = _validateUserId($params->{user_id});
	Common::mergeHash($errors, $userIdErrors);

	my $titleErrors = _validateTitle($params->{title});
	Common::mergeHash($errors, $titleErrors);

	my $bodyErrors = _validateBody($params->{body});
	Common::mergeHash($errors, $bodyErrors);

	my @keys = keys %$errors;
	$errors->{Err} = 1 if grep { /^Err/ } @keys;

	return $errors;
}

sub _validateUserId {
  my ($user_id) = @_;
	my $errors = {};

	if (!defined($user_id) || $user_id eq '') {
		$errors->{ErrUserIdPresence} = 1;
		return $errors;
	}

  my $user = Func::User::find($user_id);
  if (!defined($user)) {
		$errors->{ErrUserIdInvalid} = 1;
		return $errors;
  }

	return $errors;
}

sub _validateTitle {
  my ($title) = @_;
	my $errors = {};

	if (!defined($title) || $title eq '') {
		$errors->{ErrTitlePresence} = 1;
		return $errors;
	}

	my $len = length($title);
	if ($len > $TITLE_MAX_LENGTH) {
		$errors->{ErrTitleLength} = $len;
		return $errors;
	}

	return $errors;
}

sub _validateBody {
  my ($body) = @_;
	my $errors = {};

	if (!defined($body) || $body eq '') {
		$errors->{ErrBodyPresence} = 1;
		return $errors;
	}

	my $len = length($body);
	if ($len > $BODY_MAX_LENGTH) {
		$errors->{ErrBodyLength} = $len;
		return $errors;
	}

	return $errors;
}

sub create {
  my ($params) = @_;

	my $errors = validate($params);
	return 0 if $errors->{Err} == 1;

	my $dbh = DA::getHandle($_::DB_USER_W);
	$dbh->do("INSERT INTO articles(user_id, title, body, created_at, updated_at)
	         VALUE(?, ?, ?, NOW(), NOW())",
	         undef, $params->{user_id}, $params->{title}, $params->{body});
  return 1;
}

sub update {
  my ($params) = @_;

	my $errors = validate($params);
	return 0 if $errors->{Err} == 1;

	my $dbh = DA::getHandle($_::DB_USER_W);
	$dbh->do("UPDATE articles
           SET user_id = ?, title = ?, body =?, updated_at = NOW()
	         WHERE id = ?",
	         undef, $params->{user_id}, $params->{title}, $params->{body}, $params->{id});
  return 1;
}

sub destroy {
  my ($id) = @_;

  return 0 if !defined($id);

	my $dbh = DA::getHandle($_::DB_USER_W);
	$dbh->do("DELETE FROM articles
	         WHERE id = ?",
	         undef, $id);

  return 1;
}

1;
