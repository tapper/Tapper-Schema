package Tapper::Schema::TestrunDB::Result::ChartTinyUrlRelations;

# ABSTRACT: Tapper - Keep static Chart Url Relations for Tapper-Reports-Web-GUI

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table('chart_tiny_url_relations');
__PACKAGE__->add_columns(
    'chart_tiny_url_line_id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 12,
        is_foreign_key      => 1,
        extra               => {
            unsigned => 1,
        },
    },
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
);

(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->set_primary_key(
    'chart_tiny_url_line_id',
    'bench_value_id',
);

__PACKAGE__->belongs_to(
    chart_tiny_url_line => "${basepkg}::ChartTinyUrlLines", { 'foreign.chart_tiny_url_line_id' => 'self.chart_tiny_url_line_id'  },
);

1;
