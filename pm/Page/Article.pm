package Page::Article;

use strict;
use MobaConf;

use Common;
use Encode;
use Flash;
use HTMLTemplate;
use Response;
use Func::Article;

sub pageIndex {
	my $func = shift;
	my $rhData = {};

	my $articles = Func::Article::all();
	my $rhData->{articles} = $articles;

	my $html = HTMLTemplate::insert("/article/index", $rhData);
	Response::output(\$html);
}

sub pageShow {
	my $func = shift;
	my $rhData = {};

	my $article = Func::Article::find($_::F->{id});
	Common::mergeHash($rhData, $article);

	my $html = HTMLTemplate::insert("/article/show", $rhData);
	Response::output(\$html);
}

1;
