package Tapper::Schema::TestrunDB::Result::BenchAdditionalTypes;

# ABSTRACT: Tapper - types of additional values for benchmark data points

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table('bench_additional_types');
__PACKAGE__->add_columns(
    'bench_additional_type_id', {
        data_type           => 'TINYINT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 4,
        is_auto_increment   => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'bench_additional_type', {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 0,
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

__PACKAGE__->set_primary_key('bench_additional_type_id');
__PACKAGE__->add_unique_constraint(
    'ux_bench_additional_types_01' => ['bench_additional_type'],
);
__PACKAGE__->has_many (
    bench_additional_value => "${basepkg}::BenchAdditionalValues", { 'foreign.bench_additional_type_id' => 'self.bench_additional_type_id' },
);
__PACKAGE__->has_many (
    bench_additional_type_relation => "${basepkg}::BenchAdditionalTypeRelations", { 'foreign.bench_additional_type_id' => 'self.bench_additional_type_id' },
);

1;