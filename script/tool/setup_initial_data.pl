use strict;
use warnings;
use utf8;

use MobaConf;

use DA;
use Func::Article;
use Func::User;

my $dbh = DA::getHandle($_::DB_USER_W);
$dbh->do('TRUNCATE TABLE user_data;');
$dbh->do('TRUNCATE TABLE articles;');

for my $i (1..10) {
  Func::User::create({ nickname => "user${i}", email => "user${i}\@example.com", password => 'password' });
  DA::commit();
  my $user = Func::User::find_by_email("user${i}\@example.com");

  for my $j (1..10) {
    Func::Article::create({ title=>"$user->{nickname} article${j} title", body=> "$user->{nickname} article${j} body", user_id=>$user->{user_id}} );
  }
  DA::commit();
}
