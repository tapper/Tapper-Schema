package Tapper::Schema::TestrunDB::Result::BenchAdditionalValues;

# ABSTRACT: Tapper - additional values for benchmark data point

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table('bench_additional_values');
__PACKAGE__->add_columns(
    'bench_additional_value_id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 11,
        is_auto_increment   => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'bench_additional_type_id', {
        data_type           => 'SMALLINT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 6,
        is_foreign_key      => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'bench_additional_value', {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 0,
        size                => 128,
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

__PACKAGE__->set_primary_key('bench_additional_value_id');
__PACKAGE__->add_unique_constraint(
    'ux_bench_additional_values_01' => ['bench_additional_type_id','bench_additional_value'],
);
__PACKAGE__->belongs_to(
    bench_additional_type => "${basepkg}::BenchAdditionalTypes", { 'foreign.bench_additional_type_id' => 'self.bench_additional_type_id'  },
);

1;

=head1 SYNOPSIS

Abstraction for the database table.

 use Tapper::Schema::TestrunDB;

=head1 BUGS

None.