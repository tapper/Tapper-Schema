package Artemis::Schema::TestrunDB;

use strict;
use warnings;

our $VERSION = '1.001';

use parent 'DBIx::Class::Schema';

our $NULL  = 'NULL';
our $DELIM = ' | ';

__PACKAGE__->load_components(qw/+DBIx::Class::Schema::Versioned/);
__PACKAGE__->load_namespaces;

__PACKAGE__->upgrade_directory('testrundb/upgrades/');
__PACKAGE__->backup_directory('testrundb/backups/');


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

