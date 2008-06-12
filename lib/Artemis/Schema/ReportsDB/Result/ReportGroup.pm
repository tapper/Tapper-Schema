package Artemis::Schema::ReportsDB::Result::ReportGroup;

use strict;
use warnings;

use parent 'DBIx::Class';
use parent 'Artemis::Schema::Printable';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("reportgroup");
__PACKAGE__->add_columns
    (
     "id",                        { data_type => "INT",      default_value => undef,  is_nullable => 0, size => 11, is_auto_increment => 1, },
     "group_id",                  { data_type => "INT",      default_value => undef,  is_nullable => 0, size => 11,                         },
     "report_id",                 { data_type => "INT",      default_value => undef,  is_nullable => 0, size => 11, is_foreign_key => 1,    },
    );

__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many   ( report => 'Artemis::Schema::ReportsDB::Result::Report', { 'foreign.id' => 'self.report_id' });


# -------------------- methods on results --------------------


1;

=head1 NAME

Artemis::Schema::ReportsDB::ReportGroup - A ResultSet description


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

