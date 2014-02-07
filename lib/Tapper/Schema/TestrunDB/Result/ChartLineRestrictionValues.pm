package Tapper::Schema::TestrunDB::Result::ChartLineRestrictionValues;

# ABSTRACT: Tapper - Keep Chart Line Restrictions value for Charts

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/FilterColumn InflateColumn::DateTime Core/);
__PACKAGE__->table('chart_line_restriction_values');
__PACKAGE__->add_columns(
    'chart_line_restriction_value_id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 11,
        is_auto_increment   => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'chart_line_restriction_id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 11,
        extra               => {
            unsigned => 1,
        },
    },
    'chart_line_restriction_value'   , {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 0,
        size                => 512,
    },
);


(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->set_primary_key('chart_line_restriction_value_id');

__PACKAGE__->belongs_to(
    chart => "${basepkg}::ChartLineRestrictions",
    { 'foreign.chart_line_restriction_id' => 'self.chart_line_restriction_id' },
);

1;