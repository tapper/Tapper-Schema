package Tapper::Schema::TestrunDB;

use 5.010;

use strict;
use warnings;

# Only increment this version here on schema changes.
# For everything else increment Tapper/Schema.pm.
our $VERSION = '3.000001';

# avoid these warnings
#   Subroutine initialize redefined at /2home/ss5/perl510/lib/site_perl/5.10.0/Class/C3.pm line 70.
#   Subroutine uninitialize redefined at /2home/ss5/perl510/lib/site_perl/5.10.0/Class/C3.pm line 88.
#   Subroutine reinitialize redefined at /2home/ss5/perl510/lib/site_perl/5.10.0/Class/C3.pm line 101.
# by forcing correct load order.
use Class::C3;
use MRO::Compat;
use YAML::Syck;

use parent 'DBIx::Class::Schema';

our $NULL  = 'NULL';
our $DELIM = ' | ';

__PACKAGE__->load_components(qw/+DBIx::Class::Schema::Versioned/);
__PACKAGE__->upgrade_directory('./upgrades/');
__PACKAGE__->backup_directory('./upgrades/');

__PACKAGE__->load_namespaces;


sub backup
{
        #say STDERR "(TODO: Implement backup method.)";
        1;
}

=head2 _yaml_ok

Check whether given string is valid yaml.

@param string - yaml

@return success - undef
@return error   - error string

=cut

sub _yaml_ok {
        my ($condition) = @_;

        my @res;
        eval {
                @res = Load($condition);
        };
        return $@;
}

1;

