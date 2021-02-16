package Page::My::Profile;

use strict;
use MobaConf;

use Common;
use DA;
use Flash;
use HTMLTemplate;
use MLog;
use Response;

use Func::User;

sub pageShow {
	my $func = shift;
	my $rhData = {};

	my $user = Func::User::find($_::U->{USER_ID});

	Common::mergeHash($rhData, $user);
	my $html = HTMLTemplate::insert("my/profile/show", $rhData);
	Response::output(\$html);
}

sub pageEdit {
	my $func = shift;
	my $rhData = {};

	my $user = Func::User::find($_::U->{USER_ID});

	Common::mergeHash($rhData, $user);
	my $html = HTMLTemplate::insert("my/profile/edit", $rhData);
	Response::output(\$html);
}

sub pageUpdate {
	my $func = shift;
	my $rhData = {};
	Common::mergeHash($rhData, $_::F);

	my $user = Func::User::find($_::U->{USER_ID});

	$rhData->{user_id} = $_::U->{USER_ID};
	my $errors = Func::User::validate($rhData);
	my @keys = keys %$errors;
	if (grep { /^Err/ } @keys) {
		Common::mergeHash($rhData, $errors);
		my $html = HTMLTemplate::insert("my/profile/edit", $rhData);
		Response::output(\$html);
	} else {
		Func::User::update($rhData);
		DA::commit();
		Flash::set('更新しました。', 'success');
		Response::redirect("/my/user");
	}
}

1;
