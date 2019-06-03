package Page::Top;

use strict;
use MobaConf;
use Common;
use HTMLTemplate;
use Response;
use DA;

#-----------------------------------------------------------
# トップページ

sub pageMain {
	my $func = shift;
	my $rhData = {};

	MLog::write("$_::LOG_DIR/debug", "Page::Top::pageMain");
	my $html = HTMLTemplate::insert("top/top", $rhData);
	MLog::write("$_::LOG_DIR/debug", "after HTMLTemplate::insert");
	MLog::write("$_::LOG_DIR/debug", "$html");
	Response::output(\$html);
}

1;
