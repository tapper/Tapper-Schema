package Artemis::Schema::TestsDB::Version;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("version");
__PACKAGE__->add_columns(
  "version",
  { data_type => "INT", default_value => "", is_nullable => 0, size => 10 },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-04-28 17:22:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:brYpMFgfDdSEBSm7EiwcNw

__PACKAGE__->set_primary_key("version");

1;

=head1 NAME

Artemis::Schema::TestsDB::Version - A ResultSet description


=head1 SYNOPSIS

Abstraction for the database table.

 use Artemis::Schema::TestsDB;


=head1 EXPORT

A list of functions that can be exported.  


=head1 FUNCTIONS


=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive

