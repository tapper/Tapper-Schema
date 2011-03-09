package Tapper::Schema::ReportsDB::Result::ReportTopic;

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

__PACKAGE__->belongs_to   ( report => 'Tapper::Schema::ReportsDB::Result::Report', { 'foreign.id' => 'self.report_id' });


1;

=head1 NAME

Tapper::Schema::ReportsDB::ReportTopic - A ResultSet description


=head1 SYNOPSIS

Abstraction for the database table.

 use Tapper::Schema::ReportsDB;


=head1 AUTHOR

AMD OSRC Tapper Team, C<< <tapper at amd64.org> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008-2011 AMD OSRC Tapper Team, all rights reserved.

This program is released under the following license: freebsd

