package Tapper::Schema::ReportsDB::Result::ReportgroupTestrun;

use 5.010;
use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("reportgrouptestrun");
__PACKAGE__->add_columns
    (
     "testrun_id",    { data_type => "INT",     default_value => undef,  is_nullable => 0, size => 11, is_foreign_key => 1, },
     "report_id",     { data_type => "INT",     default_value => undef,  is_nullable => 0, size => 11, is_foreign_key => 1, },
     "primaryreport", { data_type => "INT",     default_value => undef,  is_nullable => 1, size => 11,                      },
    );

__PACKAGE__->set_primary_key(qw/testrun_id report_id/);

__PACKAGE__->might_have ( reportgrouptestrunstats => 'Tapper::Schema::ReportsDB::Result::ReportgroupTestrunStats', { 'foreign.testrun_id' => 'self.testrun_id' }, { is_foreign_key_constraint => 0 } );
__PACKAGE__->belongs_to ( report => 'Tapper::Schema::ReportsDB::Result::Report', { 'foreign.id' => 'self.report_id' } );

# -------------------- methods on results --------------------

sub groupreports {
        my ($self) = @_;

        my @report_ids;
        my $rg = $self->result_source->schema->resultset('ReportgroupTestrun')->search({ testrun_id => $self->testrun_id });
        while (my $rg_entry = $rg->next) {
                push @report_ids, $rg_entry->report_id;
        }
        return $self->result_source->schema->resultset('Report')->search({ id => [ -or => [ @report_ids ] ] });
}

1;

=head1 NAME

Tapper::Schema::ReportsDB::ReportGroup - A ResultSet description


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

