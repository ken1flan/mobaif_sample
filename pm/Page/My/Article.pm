package Page::My::Article;

use strict;
use MobaConf;

use Common;
use HTMLTemplate;
use Response;
use DA;

use Func::User;
use Func::Article;

sub pageIndex {
	my $func = shift;
	my $rhData = {};

	my $html = HTMLTemplate::insert("my/article/index", $rhData);
	Response::output(\$html);
}

sub pageShow {
	my $func = shift;
	my $rhData = {};

	my $html = HTMLTemplate::insert("my/article/show", $rhData);
	Response::output(\$html);
}

sub pageNew {
	my $func = shift;
	my $rhData = {};

	my $html = HTMLTemplate::insert("my/article/new", $rhData);
	Response::output(\$html);
}

sub pageCreate {
	my $func = shift;
	my $rhData = {};

	my $html = HTMLTemplate::insert("my/article/create", $rhData);
	Response::output(\$html);
}

sub pageEdit {
	my $func = shift;
	my $rhData = {};

	my $html = HTMLTemplate::insert("my/article/edit", $rhData);
	Response::output(\$html);
}

sub pageUpdate {
	my $func = shift;
	my $rhData = {};

	my $html = HTMLTemplate::insert("my/article/update", $rhData);
	Response::output(\$html);
}

sub pageEdit {
	my $func = shift;
	my $rhData = {};

	my $html = HTMLTemplate::insert("my/article/edit", $rhData);
	Response::output(\$html);
}

sub pageUpdate {
	my $func = shift;
	my $rhData = {};

	my $html = HTMLTemplate::insert("my/article/update", $rhData);
	Response::output(\$html);
}

sub pageDestroy {
	my $func = shift;
	my $rhData = {};

	my $html = HTMLTemplate::insert("my/article/destroy", $rhData);
	Response::output(\$html);
}

1;
