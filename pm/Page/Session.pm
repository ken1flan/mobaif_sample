package Page::Session;

use strict;
use MobaConf;

use Common;
use Encode;
use Flash;
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
		Flash::set('ログインしました。', 'success');

		Response::redirect('/');
	} else {
		$rhData->{Err} = 1;
		$rhData->{email} = $_::F->{email};

		my $html = HTMLTemplate::insert('session/new', $rhData);
	  Response::output(\$html);
	}
}

sub pageDestroy {
	my $func = shift;
	my $rhData = {};

	Flash::set('ログアウトしました。', 'success');
	Session::destroy();

	Response::redirect('/');
}

1;
