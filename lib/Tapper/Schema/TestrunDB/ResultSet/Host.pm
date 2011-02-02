package Tapper::Schema::TestrunDB::ResultSet::Host;

use 5.010;
use strict;
use warnings;

use parent 'DBIx::Class::ResultSet';
use Data::Dumper;

sub free_hosts { shift->search({ free => 1, active => 1 }) }

1;
