package Tapper::Schema::TestrunDB::Result::BenchAdditionalTypeRelations;

# ABSTRACT: Tapper - additional values for benchmark data point

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table('bench_additional_type_relations');
__PACKAGE__->add_columns(
    'bench_id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 12,
        is_foreign_key      => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'bench_additional_type_id', {
        data_type           => 'TINYINT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 4,
        is_foreign_key      => 1,
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

__PACKAGE__->set_primary_key('bench_id','bench_additional_type_id');
__PACKAGE__->belongs_to(
    bench => "${basepkg}::Benchs", { 'foreign.bench_id' => 'self.bench_id'  },
);
__PACKAGE__->belongs_to(
    bench_additional_type => "${basepkg}::BenchAdditionalTypes", { 'foreign.bench_additional_type_id' => 'self.bench_additional_type_id'  },
);

=head1 SYNOPSIS

Abstraction for the database table.

 use Tapper::Schema::TestrunDB;

=head1 AUTHOR

AMD OSRC Tapper Team, C<< <tapper at amd64.org> >>


=head1 BUGS

None.

1;