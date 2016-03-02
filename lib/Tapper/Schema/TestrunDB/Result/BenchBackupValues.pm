package Tapper::Schema::TestrunDB::Result::BenchBackupValues;

# ABSTRACT: Tapper - backup table for data points for benchmark

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table('bench_backup_values');
__PACKAGE__->add_columns(
    'bench_backup_value_id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 11,
        is_auto_increment   => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'bench_value_id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 11,
        is_foreign_key      => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'bench_id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 11,
        is_foreign_key      => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'bench_subsume_type_id', {
        data_type           => 'SMALLINT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 6,
        is_foreign_key      => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'bench_value', {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 0,
        size                => 512,
    },
    'active', {
        data_type           => 'TINYINT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 4,
        extra               => {
            unsigned => 1,
        },
    },
    'created_at', {
        data_type           => 'TIMESTAMP',
        default_value       => undef,
        is_nullable         => 0,
        set_on_create       => 1,
    },
);

(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->set_primary_key('bench_backup_value_id');
__PACKAGE__->belongs_to(
    bench => "${basepkg}::Benchs", { 'foreign.bench_id' => 'self.bench_id'  },
);
__PACKAGE__->belongs_to(
    bench_value => "${basepkg}::BenchValues", { 'foreign.bench_value_id' => 'self.bench_value_id'  },
);
__PACKAGE__->belongs_to(
    bench_subsume_type => "${basepkg}::BenchSubsumeTypes", { 'foreign.bench_subsume_type_id' => 'self.bench_subsume_type_id'  },
);
__PACKAGE__->has_many (
    bench_backup_additional_relation => "${basepkg}::BenchBackupAdditionalRelations", { 'foreign.bench_backup_value_id' => 'self.bench_backup_value_id' },
);

1;
