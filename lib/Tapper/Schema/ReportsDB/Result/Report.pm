package Tapper::Schema::ReportsDB::Result::Report;

use 5.010;
use strict;
use warnings;

use parent 'DBIx::Class';

use Data::Dumper;

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

__PACKAGE__->belongs_to   ( suite                => 'Tapper::Schema::ReportsDB::Result::Suite',                { 'foreign.id'        => 'self.suite_id' }, { 'join_type' => 'LEFT OUTER' });
__PACKAGE__->might_have   ( reportgrouparbitrary => 'Tapper::Schema::ReportsDB::Result::ReportgroupArbitrary', { 'foreign.report_id' => 'self.id'       }, { 'join_type' => 'LEFT OUTER' });
__PACKAGE__->might_have   ( reportgrouptestrun   => 'Tapper::Schema::ReportsDB::Result::ReportgroupTestrun',   { 'foreign.report_id' => 'self.id'       }, { 'join_type' => 'LEFT OUTER' });
__PACKAGE__->might_have      ( tap                  => 'Tapper::Schema::ReportsDB::Result::Tap',                 { 'foreign.report_id'        => 'self.id' }, { 'join_type' => 'LEFT OUTER' });

__PACKAGE__->has_many     ( comments       => 'Tapper::Schema::ReportsDB::Result::ReportComment', { 'foreign.report_id' => 'self.id' });
__PACKAGE__->has_many     ( topics         => 'Tapper::Schema::ReportsDB::Result::ReportTopic',   { 'foreign.report_id' => 'self.id' });
__PACKAGE__->has_many     ( files          => 'Tapper::Schema::ReportsDB::Result::ReportFile',    { 'foreign.report_id' => 'self.id' });
__PACKAGE__->has_many     ( reportsections => 'Tapper::Schema::ReportsDB::Result::ReportSection', { 'foreign.report_id' => 'self.id' });


sub sqlt_deploy_hook
{
        my ($self, $sqlt_table) = @_;
        $sqlt_table->add_index(name => 'report_idx_machine_name', fields => ['machine_name']);
}

#sub suite_name { shift->suite->name }
#sub suite_name { my ($self, $arg) = @_; return $self->search({ "suite.name" => $arg })};

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

sub some_meta_available
{
        my ($self) = @_;

        my $sections = $self->reportsections;
        while (my $section = $sections->next) {
                return 1 if $section->some_meta_available;
        }
        return 0;
}

sub get_cached_tapdom
{
        my ($r) = @_;

        require Tapper::TAP::Harness;
        require TAP::DOM;

        my $TAPVERSION = "TAP Version 13";
        my $tapdom_sections = [];

        my $report     = $r->result_source->schema->resultset('Report')->find($r->id);
        my $tapdom_str = $report->tap->tapdom;

        # set TAPPER_FORCE_NEW_TAPDOM to force the re-generation of the TAP DOM, e.g. when the TAP::DOM module changes
        if ($tapdom_str and not -e '/tmp/TAPPER_FORCE_NEW_TAPDOM')
        {
                #say STDERR "EVAL ", $r->id;
                eval '$tapdom_sections = my '.$tapdom_str; ## no critic (ProhibitStringyEval)
        }
        else
        {
                # say STDERR "RUN TAPPER::TAP::HARNESS ", $r->id;

                my $report_tap     = $report->tap->tap;
                my $tap_is_archive = $report->tap->tap_is_archive || 0;

                # We got "Out of memory!" with monster TAP reports.
                if (length $report_tap > 2_000_000) {
                        warn "Ignore report ".$r->id." due to too large TAP. ";
                }
                else
                {
                        my $harness = new Tapper::TAP::Harness( tap            => $report_tap,
                                                                 tap_is_archive => $tap_is_archive );
                        $harness->evaluate_report();
                        #print STDERR Dumper($harness->parsed_report);
                        foreach (@{$harness->parsed_report->{tap_sections}})
                        {
                                #print STDERR ".";
                                my $rawtap = $_->{raw} || '';
                                #say STDERR "x"x100, "\n", $rawtap, "\n", "x"x 100;
                                $rawtap    = $TAPVERSION."\n".$rawtap unless $rawtap =~ /^TAP Version/ms;
                                #say STDERR length($rawtap);
                                my $tapdom = new TAP::DOM ( tap    => $rawtap,
                                                            ignore => [qw( raw as_string )],
                                                            ignorelines => qr/^\#\# /,        # mostly used in oprofile
                                                          );
                                push @$tapdom_sections, { section => { $_->{section_name} => { tap     => $tapdom,
                                                                                               meta => $_->{section_meta},
                                                                                             }
                                                                     }
                                                        };
                        }
                        $tapdom_str = Dumper($tapdom_sections);
                        $report->tap->tapdom( $tapdom_str );
                        #say STDERR "new report: ", Dumper($report);
                        $report->tap->update;
                        $report->update;
                }
        }
        #print STDERR ".\n";
        return $tapdom_sections;
}

1;

__END__

=head1 NAME

Tapper::Schema::ReportsDB::Report - A ResultSet description


=head1 SYNOPSIS

Abstraction for the database table.

 use Tapper::Schema::ReportsDB;


=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008-2011 AMD OSRC Tapper Team, all rights reserved.

This program is released under the following license: freebsd

