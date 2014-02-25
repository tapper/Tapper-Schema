package Tapper::Schema::TestrunDB::Result::ChartLineRestrictions;

# ABSTRACT: Tapper - Keep Chart Line Restrictions for Charts

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/FilterColumn InflateColumn::DateTime Core/);
__PACKAGE__->table('chart_line_restrictions');
__PACKAGE__->add_columns(
    'chart_line_restriction_id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 11,
        is_auto_increment   => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'chart_line_id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 11,
        is_foreign_key      => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'chart_line_restriction_operator'   , {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 0,
        size                => 4,
    },
    'chart_line_restriction_column'   , {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 0,
        size                => 512,
    },
    'is_template_restriction', {
        data_type           => 'TINYINT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 3,
        extra               => {
            unsigned => 1,
        },
    },
    'is_numeric_restriction', {
        data_type           => 'TINYINT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 3,
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

__PACKAGE__->set_primary_key('chart_line_restriction_id');

__PACKAGE__->belongs_to(
    chart => "${basepkg}::ChartLines",
    { 'foreign.chart_line_id' => 'self.chart_line_id' },
);
__PACKAGE__->has_many(
    chart_line_restriction_values => "${basepkg}::ChartLineRestrictionValues",
    { 'foreign.chart_line_restriction_id' => 'self.chart_line_restriction_id' },
);

1;