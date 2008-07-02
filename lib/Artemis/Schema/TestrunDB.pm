package Artemis::Schema::TestrunDB;

use 5.010;

use strict;
use warnings;

our $VERSION = '2.010009';

use parent 'DBIx::Class::Schema';

our $NULL  = 'NULL';
our $DELIM = ' | ';

__PACKAGE__->load_components(qw/+DBIx::Class::Schema::Versioned/);
__PACKAGE__->load_namespaces;

__PACKAGE__->upgrade_directory('/var/tmp/');
__PACKAGE__->backup_directory('/var/tmp/');


sub backup
{
        #say STDERR "(TODO: Implement backup method.)";
        1;
}

1;

=head1 NAME

Artemis::Schema::TestrunDB - Artemis Database Schema for Testruns

=hea1 VERSION

Version 0.01

=head1 SYNOPSIS

 use Artemis::Schema::TestrunDB;

=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>

=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive

