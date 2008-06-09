package Artemis::Schema::ReportsDB::Result::ReportComment;

use strict;
use warnings;

use parent 'DBIx::Class';
use parent 'Artemis::Schema::Printable';

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table("reportcomment");
__PACKAGE__->add_columns
    (
     "id",                        { data_type => "INT",      default_value => undef,  is_nullable => 0, size => 11     },
     "report_id",                 { data_type => "INT",      default_value => undef,  is_nullable => 0, size => 11     },
     "user_id",                   { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 11     },
     "comment",                   { data_type => "TEXT",     default_value => "",     is_nullable => 0, size => 65535  },
     "created_at",                { data_type => "DATETIME", default_value => undef,  is_nullable => 1, size => 19     },
     "updated_at",                { data_type => "DATETIME", default_value => undef,  is_nullable => 1, size => 19     },
    );

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to   ( report => 'Artemis::Schema::ReportsDB::Result::Report', { 'foreign.id' => 'self.report_id' });
__PACKAGE__->belongs_to   ( user   => 'Artemis::Schema::ReportsDB::Result::User',   { 'foreign.id' => 'self.user_id' });


1;

=head1 NAME

Artemis::Schema::ReportsDB::ReportComment - A ResultSet description


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

