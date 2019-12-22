package Session;

use strict;
use MobaConf;

use Data::Dumper;
use Func::User;
use Text::Password::SHA;

sub create {
  my ($email, $password) = @_;

  my $user = Func::User::find_by_email($email);
  return 0 unless (defined($user));

  my $pwd = Text::Password::SHA->new();
  return 0 unless ($pwd->verify($password, $user->{hashed_password}));

  # TODO: Reset session_id
  $_::S->param("user_id", $user->{user_id});

  return 1;
}

1;
