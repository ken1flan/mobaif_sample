package Func::Article;

use strict;

use MobaConf;

use Common;
use DA;

sub find {
  my ($id) = @_;

	my $dbh = DA::getHandle($_::DB_USER_R);
	my $row = $dbh->selectrow_hashref("SELECT * FROM articles WHERE id = ?", undef, ($id));
	return $row;
}

sub search_by_user_id {
  my ($user_id) = @_;

  # TODO
}

sub validate {
  my ($params) = @_;

  # TODO
}

sub create {
  my ($params) = @_;

	my $dbh = DA::getHandle($_::DB_USER_W);
	$dbh->do("INSERT INTO articles(user_id, title, body, created_at, updated_at)
	         VALUE(?, ?, ?, NOW(), NOW())",
	         undef, $params->{user_id}, $params->{title}, $params->{body});
  return 1;
}

sub update {
  my ($params) = @_;

  # TODO
}

sub destroy {
  my ($id) = @_;

  # TODO
}

1;
