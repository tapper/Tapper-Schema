package Artemis::Schema::TestrunDB;

use 5.010;

use strict;
use warnings;

# Only increment this version here on schema changes.
# For everything else increment Artemis/Schema.pm.
our $VERSION = '2.010014';

# avoid these warnings
#   Subroutine initialize redefined at /2home/ss5/perl510/lib/site_perl/5.10.0/Class/C3.pm line 70.
#   Subroutine uninitialize redefined at /2home/ss5/perl510/lib/site_perl/5.10.0/Class/C3.pm line 88.
#   Subroutine reinitialize redefined at /2home/ss5/perl510/lib/site_perl/5.10.0/Class/C3.pm line 101.
# by forcing correct load order.
use Class::C3;
use MRO::Compat;

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

