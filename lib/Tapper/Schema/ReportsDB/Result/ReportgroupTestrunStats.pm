package Tapper::Schema::ReportsDB::Result::ReportgroupTestrunStats;

use 5.010;
use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("reportgrouptestrunstats");
__PACKAGE__->add_columns
    (
     "testrun_id",    { data_type => "INT",     default_value => undef,  is_nullable => 0,  size => 11, is_foreign_key => 1, },
     "total",         { data_type => "INT",     default_value => undef,  is_nullable => 1,  size => 10,                      },
     "failed",        { data_type => "INT",     default_value => undef,  is_nullable => 1,  size => 10,                      },
     "passed",        { data_type => "INT",     default_value => undef,  is_nullable => 1,  size => 10,                      },
     "parse_errors",  { data_type => "INT",     default_value => undef,  is_nullable => 1,  size => 10,                      },
     "skipped",       { data_type => "INT",     default_value => undef,  is_nullable => 1,  size => 10,                      },
     "todo",          { data_type => "INT",     default_value => undef,  is_nullable => 1,  size => 10,                      },
     "todo_passed",   { data_type => "INT",     default_value => undef,  is_nullable => 1,  size => 10,                      },
     "wait",          { data_type => "INT",     default_value => undef,  is_nullable => 1,  size => 10,                      },
     "success_ratio", { data_type => "VARCHAR", default_value => undef,  is_nullable => 1,  size => 20,                      },
     # "exit" makes wrong SQL
     # "exit",         { data_type => "INT",  default_value => undef,  is_nullable => 1,  size => 10,                      },
    );

__PACKAGE__->set_primary_key(qw/testrun_id/);

__PACKAGE__->has_many ( reportgrouptestruns => 'Tapper::Schema::ReportsDB::Result::ReportgroupTestrun', { 'foreign.testrun_id' => 'self.testrun_id' }, {cascade_delete => 0, cascade_copy => 0 } );

sub groupreports {
        my ($self) = @_;

        $self->reportgrouptestruns->groupreports;
}

sub _success_ratio
{
        my ($self) = @_;

        my $ratio = sprintf("%02.2f", $self->total ? ($self->passed / $self->total * 100) : 100 );
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

        my $reports_rs = $self->groupreports;
        no strict 'refs'; ## no critic (ProhibitNoStrict)
        my %sums = ();
        my @stat_fields = (qw/failed passed total parse_errors skipped todo todo_passed wait/); # no "exit", that would create wrong SQL
        while (my $r = $reports_rs->next) {
                $sums{$_} += ($r->$_ // 0) foreach @stat_fields;
        }
        $self->$_($sums{$_}) foreach @stat_fields;
        $self->success_ratio( $self->_success_ratio );
        return $self;
}

1;

=head1 NAME

Tapper::Schema::ReportsDB::ReportgroupTestrunMeta.pm -  Meta info for Reports grouped by Testrun

=head1 SYNOPSIS

Abstraction for the database table.

 use Tapper::Schema::ReportsDB::ReportgroupTestrunMeta;


=head1 AUTHOR

AMD OSRC Tapper Team, C<< <tapper at amd64.org> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008-2011 AMD OSRC Tapper Team, all rights reserved.

This program is released under the following license: freebsd

