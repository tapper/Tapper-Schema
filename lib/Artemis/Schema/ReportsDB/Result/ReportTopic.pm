package Artemis::Schema::ReportsDB::Result::ReportTopic;

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("reporttopic");
__PACKAGE__->add_columns
    (
     "id",                        { data_type => "INT",      default_value => undef,  is_nullable => 0, size => 11, is_auto_increment => 1, },
     "report_id",                 { data_type => "INT",      default_value => undef,  is_nullable => 0, size => 11, is_foreign_key => 1,    },
     "name",                      { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 50,                         },
     "details",                   { data_type => "TEXT",     default_value => "",     is_nullable => 0,                                     },
    );

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to   ( report => 'Artemis::Schema::ReportsDB::Result::Report', { 'foreign.id' => 'self.report_id' });


1;

=head1 NAME

Artemis::Schema::ReportsDB::ReportTopic - A ResultSet description


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

