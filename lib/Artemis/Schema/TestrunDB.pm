package Artemis::Schema::TestrunDB;

use 5.010;

use strict;
use warnings;

our $VERSION = '2.010010';

use parent 'DBIx::Class::Schema';

our $NULL  = 'NULL';
our $DELIM = ' | ';

__PACKAGE__->load_components(qw/+DBIx::Class::Schema::Versioned/);
__PACKAGE__->upgrade_directory('/var/tmp/');
__PACKAGE__->backup_directory('/var/tmp/');

__PACKAGE__->load_namespaces;


sub backup
{
        #say STDERR "(TODO: Implement backup method.)";
        1;
}

1;

