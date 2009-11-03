package Artemis::Schema::ReportsDB::Result::ReportgroupTestrunStats;

use 5.010;
use strict;
use warnings;

use parent 'DBIx::Class';
use parent 'Artemis::Schema::Printable';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("reportgrouptestrunstats");
__PACKAGE__->add_columns
    (
     "testrun_id",   { data_type => "INT",  default_value => undef,  is_nullable => 0,  size => 11, is_foreign_key => 1, },
     "total",        { data_type => "INT",  default_value => undef,  is_nullable => 1,  size => 10,                      },
     "failed",       { data_type => "INT",  default_value => undef,  is_nullable => 1,  size => 10,                      },
     "passed",       { data_type => "INT",  default_value => undef,  is_nullable => 1,  size => 10,                      },
     "parse_errors", { data_type => "INT",  default_value => undef,  is_nullable => 1,  size => 10,                      },
     "skipped",      { data_type => "INT",  default_value => undef,  is_nullable => 1,  size => 10,                      },
     "todo",         { data_type => "INT",  default_value => undef,  is_nullable => 1,  size => 10,                      },
     "todo_passed",  { data_type => "INT",  default_value => undef,  is_nullable => 1,  size => 10,                      },
     "wait",         { data_type => "INT",  default_value => undef,  is_nullable => 1,  size => 10,                      },
     # "exit" makes wrong SQL
     # "exit",         { data_type => "INT",  default_value => undef,  is_nullable => 1,  size => 10,                      },
    );

__PACKAGE__->set_primary_key(qw/testrun_id/);

__PACKAGE__->belongs_to ( reportgrouptestruns => 'Artemis::Schema::ReportsDB::Result::ReportgroupTestrun', { 'foreign.testrun_id' => 'self.testrun_id' }, {cascade_delete => 0, cascade_copy => 0 } );

sub success_ratio
{
        my ($self) = @_;

        my $ratio = $self->passed / $self->total;
        return $ratio;
}

sub update_failed_passed
{
        my ($self) = @_;

        my $failed       = 0;
        my $passed       = 0;
        my $total        = 0;
        my $parse_errors = 0;
        my $skipped      = 0;
        my $todo         = 0;
        my $todo_passed  = 0;
        my $wait         = 0;
        my $exit         = 0;

        my $reports_rs = $self->reportgrouptestruns->reports->search({}); # HIER WEITER: das liefert irgendwie nur den ersten
        no strict 'refs';
        while (my $r = $reports_rs->next) {
                print STDERR "*** update_reportgroup_testrun_stats: r = ", $r->id, "\n";

                # no "exit", that would create wrong SQL
                foreach (qw/failed passed total parse_errors skipped todo todo_passed wait/) {
                        ${$_} += ($r->$_ // 0);
                }
        }
        # no "exit", that would create wrong SQL
        foreach (qw/failed passed total parse_errors skipped todo todo_passed wait/) {
                print STDERR "*** ", $self->$_, " + ", ${$_}, "\n";
                $self->$_($self->$_ + ${$_});
        }
        return $self;
}

1;

=head1 NAME

Artemis::Schema::ReportsDB::ReportgroupTestrunMeta.pm -  Meta info for Reports grouped by Testrun

=head1 SYNOPSIS

Abstraction for the database table.

 use Artemis::Schema::ReportsDB::ReportgroupTestrunMeta;


=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2009 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive

