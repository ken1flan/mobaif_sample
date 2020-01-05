use encoding "cp932";

use MobaConf;

use Carp::Always;
use Data::Dumper;

use DA;
use Func::Article;

my $dbh = DA::getHandle($_::DB_USER_W);
my $rows = $dbh->selectall_arrayref("show variables like 'chara%'");
print Data::Dumper::Dumper($rows);

my $title = "abc";
my $body = "xyz";
my $article_params = {title => $title, body => $body, user_id => 1};
my $ret = Func::Article::create($article_params);
DA::commit();

$article_params->{title} = "‚ ‚¢‚¤";
Func::Article::create($article_params);

print "OK\n";

DA::commit();
