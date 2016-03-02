package Tapper::Schema::TestrunDB::Result::ReportgroupTestrunStats;

# ABSTRACT: Tapper - Containing additional aggregated data to testruns

use 5.010;
use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components('Core');
__PACKAGE__->table('reportgrouptestrunstats');
__PACKAGE__->add_columns(
    'testrun_id', {
        data_type       => 'INT',
        default_value   => undef,
        is_nullable     => 0,
        size            => 11,
        is_foreign_key  => 1,
    },
    'total', {
        data_type       => 'INT',
        default_value   => undef,
        is_nullable     => 1,
        size            => 10,
    },
    'failed', {
        data_type       => 'INT',
        default_value   => undef,
        is_nullable     => 1,
        size            => 10,
    },
    'passed', {
        data_type       => 'INT',
        default_value   => undef,
        is_nullable     => 1,
        size            => 10,
    },
    'parse_errors', {
        data_type       => 'INT',
        default_value   => undef,
        is_nullable     => 1,
        size            => 10,
    },
    'skipped', {
        data_type       => 'INT',
        default_value   => undef,
        is_nullable     => 1,
        size            => 10,
    },
    'todo', {
        data_type       => 'INT',
        default_value   => undef,
        is_nullable     => 1,
        size            => 10,
    },
    'todo_passed', {
        data_type       => 'INT',
        default_value   => undef,
        is_nullable     => 1,
        size            => 10,
    },
    'success_ratio', {
        data_type       => 'VARCHAR',
        default_value   => undef,
        is_nullable     => 1,
        size            => 20,
    },
);

__PACKAGE__->set_primary_key(qw/testrun_id/);
__PACKAGE__->has_many(
    reportgrouptestruns => 'Tapper::Schema::TestrunDB::Result::ReportgroupTestrun',
    { 'foreign.testrun_id' => 'self.testrun_id' },
    { cascade_delete => 0, cascade_copy => 0 },
);
__PACKAGE__->has_one(
    testrun => 'Tapper::Schema::TestrunDB::Result::Testrun',
    { 'foreign.id' => 'self.testrun_id' },
);


=head2 groupreports

Return all reports of this testrun report group.

=cut

sub groupreports {
        my ($self) = @_;

        $self->reportgrouptestruns->groupreports;
}

=head2 _success_ratio

Return this reports success ratio of passed vs. total.

=cut

sub _success_ratio
{
        my ($self) = @_;

        my $ratio = sprintf("%02.2f", $self->total ? ($self->passed / $self->total * 100) : 100 );
        return $ratio;
}

=head2 success_word

Reports overall success as a word - fail or pass. This word is always all
lowercase.

=cut

sub success_word
{
        my ($self) = @_;
        $self->success_ratio == 100 ? 'pass' : 'fail';
}


=head2 update_failed_passed

Update reportgroup details, eg. on incoming new reports of this group.

=cut

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
        my @stat_fields = (qw/failed passed total parse_errors skipped todo todo_passed /); # no "exit" or "wait", that would create wrong SQL
        while (my $r = $reports_rs->next) {
                $sums{$_} += ($r->$_ // 0) foreach @stat_fields;
        }
        $self->$_($sums{$_}) foreach @stat_fields;
        $self->success_ratio( $self->_success_ratio );
        return $self;
}

1;
