use strict;
use utf8;

use MobaConf;
use Test::Spec;

use Func::Article;

use Data::Dumper;
use DA;

describe 'Func::Article' => sub {
  my $dbh = DA::getHandle($_::DB_USER_W);
  after each => sub {
    $dbh->do('TRUNCATE TABLE articles;');
  };

  describe 'find' => sub {

    it 'TODO' => sub {
      # TODO
      ok(1);
    };
  };

  describe 'search_by_user_id' => sub {

    it 'TODO' => sub {
      # TODO
      ok(1);
    };
  };

  describe 'verify' => sub {

    it 'TODO' => sub {
      # TODO
      ok(1);
    };
  };
  describe 'create' => sub {

    it 'TODO' => sub {
      # TODO
      ok(1);
    };
  };

  describe 'update' => sub {

    it 'TODO' => sub {
      # TODO
      ok(1);
    };
  };

  describe 'destroy' => sub {

    it 'TODO' => sub {
      # TODO
      ok(1);
    };
  };
};

runtests unless caller;
