package Page::User;

use strict;
use MobaConf;
use Common;
use HTMLTemplate;
use Response;
use DA;
use Func::User;

sub pageShow {
	my $func = shift;
	my $rhData = {};

	my $html = HTMLTemplate::insert("user/show", $rhData);
	Response::output(\$html);
}

sub pageNew {
	my $func = shift;
	my $func = shift;
	my $rhData = {};

	my $html = HTMLTemplate::insert("user/new", $rhData);
	Response::output(\$html);
}

sub pageCreate {
	my $func = shift;
	my $rhData = {};
	Common::mergeHash($rhData, $_::F);

	my $errors = Func::User::validate($rhData);
	my @keys = keys %$errors;
	my $html = "";
	if (grep { /^Err/ } @keys) {
		Common::mergeHash($rhData, $errors);
		$html = HTMLTemplate::insert("user/new", $rhData);
	} else {
		Func::User::create($rhData);
		$html = HTMLTemplate::insert("user/create", $rhData);
		my $dbh = DA::getHandle($_::DB_USER_W);
		$dbh->commit();
	}
	Response::output(\$html);
}

1;
