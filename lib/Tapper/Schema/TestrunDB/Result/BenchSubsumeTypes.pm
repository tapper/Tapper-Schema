package Tapper::Schema::TestrunDB::Result::BenchSubsumeTypes;

# ABSTRACT: Tapper - types of subsume values

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table('bench_subsume_types');
__PACKAGE__->add_columns(
    'bench_subsume_type_id', {
        data_type           => 'TINYINT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 4,
        is_auto_increment   => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'bench_subsume_type', {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 0,
        size                => 32,
    },
    'bench_subsume_type_rank', {
        data_type           => 'TINYINT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 4,
    },
    'datetime_strftime_pattern', {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 1,
        size                => 32,
    },
    'created_at', {
        data_type           => 'TIMESTAMP',
        default_value       => undef,
        is_nullable         => 0,
        set_on_create       => 1,
    },
);


(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->set_primary_key('bench_subsume_type_id');
__PACKAGE__->add_unique_constraint(
    'ux_bench_subsume_types_01' => ['bench_subsume_type'],
);

__PACKAGE__->has_many (
    bench_value => "${basepkg}::BenchValues", { 'foreign.bench_subsume_type_id' => 'self.bench_subsume_type_id' },
);
__PACKAGE__->has_many (
    bench_backup_value => "${basepkg}::BenchBackupValues", { 'foreign.bench_subsume_type_id' => 'self.bench_subsume_type_id' },
);

sub sqlt_deploy_hook {

    my ( $or_self, $or_sqlt_table) = @_;

    # add default lines to table
    $or_sqlt_table->new({
        bench_subsume_type        => 'atomic',
        bench_subsume_type_rank   => 1,
    })->insert();
    $or_sqlt_table->new({
        bench_subsume_type        => 'second',
        bench_subsume_type_rank   => 2,
        datetime_strftime_pattern => '%Y%m%d%H%M%S',
    })->insert();
    $or_sqlt_table->new({
        bench_subsume_type        => 'minute',
        bench_subsume_type_rank   => 3,
        datetime_strftime_pattern => '%Y%m%d%H%M',
    })->insert();
    $or_sqlt_table->new({
        bench_subsume_type        => 'hour',
        bench_subsume_type_rank   => 4,
        datetime_strftime_pattern => '%Y%m%d%H',
    })->insert();
    $or_sqlt_table->new({
        bench_subsume_type        => 'day',
        bench_subsume_type_rank   => 5,
        datetime_strftime_pattern => '%Y%m%d',
    })->insert();
    $or_sqlt_table->new({
        bench_subsume_type        => 'week',
        bench_subsume_type_rank   => 6,
        datetime_strftime_pattern => '%Y%W',
    })->insert();
    $or_sqlt_table->new({
        bench_subsume_type        => 'month',
        bench_subsume_type_rank   => 7,
        datetime_strftime_pattern => '%Y%m',
    })->insert();
    $or_sqlt_table->new({
        bench_subsume_type        => 'year',
        bench_subsume_type_rank   => 8,
        datetime_strftime_pattern => '%Y',
    })->insert();

}

1;

=head1 SYNOPSIS

Abstraction for the database table.

 use Tapper::Schema::TestrunDB;

=head1 BUGS

None.