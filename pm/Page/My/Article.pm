package Page::My::Article;

use strict;
use MobaConf;

use Common;
use DA;
use Flash;
use HTMLTemplate;
use MLog;
use Response;

use Func::User;
use Func::Article;

sub pageIndex {
	my $func = shift;
	my $rhData = {};

	my $articles = Func::Article::search_by_user_id($_::U->{USER_ID});
	my $rhData->{articles} = $articles;

	my $html = HTMLTemplate::insert("my/article/index", $rhData);
	Response::output(\$html);
}

sub pageShow {
	my $func = shift;
	my $rhData = {};

	my $article = Func::Article::find($_::F->{id});

	if ($article->{user_id} == $_::U->{USER_ID}) {
		Common::mergeHash($rhData, $article);
		my $html = HTMLTemplate::insert("my/article/show", $rhData);
		Response::output(\$html);
	} else {
		Flash::set('見ることができません。', 'warning');
		Response::redirect('/my/articles');
	}
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
	Common::mergeHash($rhData, $_::F);

	$rhData->{user_id} = $_::U->{USER_ID};
	my $errors = Func::Article::validate($rhData);
	my @keys = keys %$errors;
	my $html = "";
	if (grep { /^Err/ } @keys) {
		Common::mergeHash($rhData, $errors);
		$html = HTMLTemplate::insert("my/article/new", $rhData);
		Response::output(\$html);
	} else {
		Func::Article::create($rhData);
		DA::commit();
		my $article = Func::Article::find_last_by_user_id($_::U->{USER_ID});

		Flash::set('登録しました。', 'success');
		Response::redirect("/my/articles/$article->{id}");
	}
}

sub pageEdit {
	my $func = shift;
	my $rhData = {};

	my $article = Func::Article::find($_::F->{id});

	if ($article->{user_id} == $_::U->{USER_ID}) {
		Common::mergeHash($rhData, $article);
		my $html = HTMLTemplate::insert("my/article/edit", $rhData);
		Response::output(\$html);
	} else {
		Flash::set('編集することができません。', 'warning');
		Response::redirect('/my/articles');
	}
}

sub pageUpdate {
	my $func = shift;
	my $rhData = {};
	Common::mergeHash($rhData, $_::F);

	my $article = Func::Article::find($_::F->{id});

	if ($article->{user_id} == $_::U->{USER_ID}) {
		$rhData->{user_id} = $_::U->{USER_ID};
		my $errors = Func::Article::validate($rhData);
		my @keys = keys %$errors;
		if (grep { /^Err/ } @keys) {
			Common::mergeHash($rhData, $errors);
			my $html = HTMLTemplate::insert("my/article/edit", $rhData);
			Response::output(\$html);
		} else {
			Func::Article::update($rhData);
			DA::commit();
			my $article = Func::Article::find_last_by_user_id($_::U->{USER_ID});
			Flash::set('更新しました。', 'success');
			Response::redirect("/my/articles/$article->{id}");
		}
	} else {
		Flash::set('編集することができません。', 'warning');
		Response::redirect('/my/articles');
	}
}

sub pageDestroy {
	my $func = shift;
	my $rhData = {};

	my $article = Func::Article::find($_::F->{id});

	if ($article->{user_id} == $_::U->{USER_ID}) {
		Func::Article::destroy($article->{id});
		DA::commit();

		Flash::set('削除しました。', 'success');
		Response::redirect('/my/articles');
	} else {
		Flash::set('削除することができません。', 'warning');
		Response::redirect('/my/articles');
	}
}

1;
