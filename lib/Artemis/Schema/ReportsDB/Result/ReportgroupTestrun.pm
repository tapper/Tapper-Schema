package Artemis::Schema::ReportsDB::Result::ReportgroupTestrun;

use 5.010;
use strict;
use warnings;

use parent 'DBIx::Class';
use parent 'Artemis::Schema::Printable';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("reportgrouptestrun");
__PACKAGE__->add_columns
    (
     "testrun_id",    { data_type => "INT",     default_value => undef,  is_nullable => 0, size => 11, is_foreign_key => 1, },
     "report_id",     { data_type => "INT",     default_value => undef,  is_nullable => 0, size => 11, is_foreign_key => 1, },
     "primaryreport", { data_type => "INT",     default_value => undef,  is_nullable => 1, size => 11,                      },
    );

__PACKAGE__->set_primary_key(qw/testrun_id report_id/);

__PACKAGE__->has_many   ( reports                 => 'Artemis::Schema::ReportsDB::Result::Report',                  { 'foreign.id'         => 'self.report_id'  });
__PACKAGE__->might_have ( reportgrouptestrunstats => 'Artemis::Schema::ReportsDB::Result::ReportgroupTestrunStats', { 'foreign.testrun_id' => 'self.testrun_id' });

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

