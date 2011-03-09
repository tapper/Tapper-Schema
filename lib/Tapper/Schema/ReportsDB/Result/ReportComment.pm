package Tapper::Schema::ReportsDB::Result::ReportComment;

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime TimeStamp Core/);
__PACKAGE__->table("reportcomment");
__PACKAGE__->add_columns
    (
     "id",         { data_type => "INT",      default_value => undef,  is_nullable => 0, size => 11, is_auto_increment => 1,     },
     "report_id",  { data_type => "INT",      default_value => undef,  is_nullable => 0, size => 11, is_foreign_key => 1,        },
     "user_id",    { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 11, is_foreign_key => 1,        },
     "succession", { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                             },
     "comment",    { data_type => "TEXT",     default_value => "",     is_nullable => 0,                                         },
     "created_at", { data_type => "DATETIME", default_value => undef,  is_nullable => 0, set_on_create => 1,                     },
     "updated_at", { data_type => "DATETIME", default_value => undef,  is_nullable => 0, set_on_create => 1, set_on_update => 1, },
    );

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to   ( report => 'Tapper::Schema::ReportsDB::Result::Report', { 'foreign.id' => 'self.report_id' });
__PACKAGE__->belongs_to   ( user   => 'Tapper::Schema::ReportsDB::Result::User',   { 'foreign.id' => 'self.user_id' });


1;

=head1 NAME

Tapper::Schema::ReportsDB::ReportComment - A ResultSet description


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

