package Page::Session;

use strict;
use MobaConf;

use Common;
use HTMLTemplate;
use Response;
use Session;

sub pageNew {
	my $func = shift;
	my $rhData = {};

	my $html = HTMLTemplate::insert("session/new", $rhData);
	Response::output(\$html);
}

sub pageCreate {
	my $func = shift;
	my $rhData = {};

	my $template_name;
	if (Session::create($_::F->{email}, $_::F->{password})) {
		$template_name = 'session/create';
	} else {
		$rhData->{Err} = 1;
		$rhData->{email} = $_::F->{email};
		$template_name = 'session/new';
	}

	my $html = HTMLTemplate::insert($template_name, $rhData);
	Response::output(\$html);
}

sub pageDestroy {
	my $func = shift;
	my $rhData = {};

	my $html = HTMLTemplate::insert("session/destroy", $rhData);
	Response::output(\$html);
}

1;
