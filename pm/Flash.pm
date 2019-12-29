package Flash;

use strict;
use MobaConf;

use Data::Dumper;
use Encode;
use MLog;

sub set {
  my ($message, $type) = @_;
  my $out_message = Encode::from_to($message, 'euc-jp', 'shiftjis');

  $_::S->param('flash_message', $message);
  $_::S->param('flash_type', $type);
}

sub get {
  return ($_::S->param('flash_message'), $_::S->param('flash_type'));
}

sub clear {
	$_::S->clear(['flash_message', 'flash_type']);
}

1;
