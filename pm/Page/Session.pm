package Page::Session;

use strict;
use MobaConf;
use Common;
use HTMLTemplate;
use Response;
use DA;

sub pageNew {
	my $func = shift;
	my $rhData = {};

	my $html = HTMLTemplate::insert("session/new", $rhData);
	Response::output(\$html);
}

sub pageCreate {
	my $func = shift;
	my $rhData = {};

	my $html = HTMLTemplate::insert("session/create", $rhData);
	Response::output(\$html);
}

sub pageDestroy {
	my $func = shift;
	my $rhData = {};

	my $html = HTMLTemplate::insert("session/destroy", $rhData);
	Response::output(\$html);
}

1;
