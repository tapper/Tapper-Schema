package Tapper::Schema::TestrunDB::Result::BenchAdditionalRelations;

# ABSTRACT: Tapper - add additional values to benchmarks

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table('bench_additional_relations');
__PACKAGE__->add_columns(
    'bench_value_id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 12,
        is_foreign_key      => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'bench_additional_value_id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 12,
        is_foreign_key      => 1,
        extra               => {
            unsigned => 1,
        },
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

__PACKAGE__->set_primary_key('bench_value_id','bench_additional_value_id');
__PACKAGE__->belongs_to(
    bench_value => "${basepkg}::BenchValues", { 'foreign.bench_value_id' => 'self.bench_value_id'  },
);
__PACKAGE__->belongs_to(
    bench_additional_value => "${basepkg}::BenchAdditionalValues", { 'foreign.bench_additional_value_id' => 'self.bench_additional_value_id'  },
);

=head1 SYNOPSIS

Abstraction for the database table.

 use Tapper::Schema::TestrunDB;

=head1 AUTHOR

AMD OSRC Tapper Team, C<< <tapper at amd64.org> >>


=head1 BUGS

None.

1;