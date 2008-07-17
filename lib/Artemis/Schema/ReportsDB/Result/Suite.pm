package Artemis::Schema::ReportsDB::Result::Suite;

use strict;
use warnings;

use parent 'DBIx::Class';
use parent 'Artemis::Schema::Printable';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("suite");
__PACKAGE__->add_columns
    (
     "id",          { data_type => "INT",     default_value => undef, is_nullable => 0, size => 11, is_auto_increment => 1, },
     "name",        { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 255,                        },
     "type",        { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 50,                         },
     "description", { data_type => "TEXT",    default_value => undef, is_nullable => 0,                                     },
    );

__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many   ( reports => 'Artemis::Schema::ReportsDB::Result::Report', { 'foreign.suite_id'        => 'self.id' });

1;

=head1 NAME

Artemis::Schema::ReportsDB::Result::User - A ResultSet description


=head1 SYNOPSIS

Abstraction for the database table.

 use Artemis::Schema::ReportsDB;


=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive

