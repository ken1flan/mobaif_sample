package Page::User;

use strict;
use MobaConf;
use Common;
use HTMLTemplate;
use Response;
use DA;

sub pageShow {
	my $func = shift;
	my $rhData = {};

	my $html = HTMLTemplate::insert("user/show", $rhData);
	Response::output(\$html);
}

sub pageNew {
	my $func = shift;
	my $rhData = {};

	my $html = HTMLTemplate::insert("user/new", $rhData);
	Response::output(\$html);
}

sub pageCreate {
	my $func = shift;
	my $rhData = {};

	my $html = HTMLTemplate::insert("user/create", $rhData);
	Response::output(\$html);
}

1;
