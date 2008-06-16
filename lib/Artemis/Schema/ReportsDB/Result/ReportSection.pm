package Artemis::Schema::ReportsDB::Result::ReportSection;

use strict;
use warnings;

use parent 'DBIx::Class';
use parent 'Artemis::Schema::Printable';

# TODO: 
__PACKAGE__->load_components("Core");
__PACKAGE__->table("reportsection");
__PACKAGE__->add_columns
    (
     "report_id",       { data_type => "INT", default_value => undef, is_nullable => 0, size => 11, is_foreign_key => 1, },
     "succession",      { data_type => "INT", default_value => undef, is_nullable => 1, size => 10,                      },
    );

__PACKAGE__->set_primary_key("report_id");

__PACKAGE__->has_many   ( report => 'Artemis::Schema::ReportsDB::Result::Report', { 'foreign.id' => 'self.report_id' });


# -------------------- methods on results --------------------


1;

=head1 NAME

Artemis::Schema::ReportsDB::ReportSection - A ResultSet description


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

