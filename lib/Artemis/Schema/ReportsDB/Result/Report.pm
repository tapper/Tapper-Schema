package Artemis::Schema::ReportsDB::Result::Report;

use strict;
use warnings;

use parent 'DBIx::Class';
use parent 'Artemis::Schema::Printable';

__PACKAGE__->load_components(qw(InflateColumn::DateTime TimeStamp Core));
__PACKAGE__->table("report");
__PACKAGE__->add_columns
    (
     "id",                      { data_type => "INT",      default_value => undef,  is_nullable => 0, size => 11, is_auto_increment => 1,     },
     "suite_id",                { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 11, is_foreign_key => 1,        },
     "suite_version",           { data_type => "VARCHAR",  default_value => undef,  is_nullable => 1, size => 11,                             },
     "reportername",            { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 100,                            },
     "peeraddr",                { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 20,                             },
     "peerport",                { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 20,                             },
     "peerhost",                { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 255,                            },
     #
     # raw tap
     #
     #"tap",                    { data_type => "TEXT",     default_value => "",     is_nullable => 0,                                         },
     "tap",                     { data_type => "LONGBLOB", default_value => "",     is_nullable => 0,                                         },
     "tapdata",                 { data_type => "LONGBLOB", default_value => "",     is_nullable => 0,                                         },
     #
     # tap parse result and its human interpretation
     #
     "successgrade",            { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 10,                             },
     "reviewed_successgrade",   { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 10,                             },
     #
     # tap parse results
     #
     "total",                   { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                             },
     "failed",                  { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                             },
     "parse_errors",            { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                             },
     "passed",                  { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                             },
     "skipped",                 { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                             },
     "todo",                    { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                             },
     "todo_passed",             { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                             },
     "wait",                    { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                             },
     "exit",                    { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                             },
     "success_ratio",           { data_type => "VARCHAR",  default_value => undef,  is_nullable => 1, size => 20,                             },
     #
     "starttime_test_program",  { data_type => "DATETIME", default_value => undef,  is_nullable => 1,                                         },
     "endtime_test_program",    { data_type => "DATETIME", default_value => undef,  is_nullable => 1,                                         },
     #
     "machine_name",            { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 50,                             },
     "machine_description",     { data_type => "TEXT",     default_value => "",     is_nullable => 1,                                         },
     #
     "created_at",              { data_type => "DATETIME", default_value => undef,  is_nullable => 0, set_on_create => 1,                     },
     "updated_at",              { data_type => "DATETIME", default_value => undef,  is_nullable => 0, set_on_create => 1, set_on_update => 1, },
    );

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to   ( suite                => 'Artemis::Schema::ReportsDB::Result::Suite',                { 'foreign.id'        => 'self.suite_id' });
__PACKAGE__->belongs_to   ( reportgrouparbitrary => 'Artemis::Schema::ReportsDB::Result::ReportgroupArbitrary', { 'foreign.report_id' => 'self.id'       }, { 'join_type' => 'LEFT OUTER' });
__PACKAGE__->belongs_to   ( reportgrouptestrun   => 'Artemis::Schema::ReportsDB::Result::ReportgroupTestrun',   { 'foreign.report_id' => 'self.id'       }, { 'join_type' => 'LEFT OUTER' });

__PACKAGE__->has_many     ( comments       => 'Artemis::Schema::ReportsDB::Result::ReportComment', { 'foreign.report_id' => 'self.id' });
__PACKAGE__->has_many     ( topics         => 'Artemis::Schema::ReportsDB::Result::ReportTopic',   { 'foreign.report_id' => 'self.id' });
__PACKAGE__->has_many     ( files          => 'Artemis::Schema::ReportsDB::Result::ReportFile',    { 'foreign.report_id' => 'self.id' });
__PACKAGE__->has_many     ( reportsections => 'Artemis::Schema::ReportsDB::Result::ReportSection', { 'foreign.report_id' => 'self.id' });

1;


sub sections_cpuinfo
{
        my ($self) = @_;
        my $sections = $self->reportsections;
        my @cpus;
        while (my $section = $sections->next) {
                push @cpus, $section->cpuinfo;
        }
        return @cpus;
}

sub sections_osname
{
        my ($self) = @_;
        my $sections = $self->reportsections;
        my @cpus;
        while (my $section = $sections->next) {
                push @cpus, $section->osname;
        }
        return @cpus;
}



=head1 NAME

Artemis::Schema::ReportsDB::Report - A ResultSet description


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

