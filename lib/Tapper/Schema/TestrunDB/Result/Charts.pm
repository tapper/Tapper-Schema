package Tapper::Schema::TestrunDB::Result::Charts;

# ABSTRACT: Tapper - Keep Charts for Tapper-Reports-Web-GUI

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table('charts');
__PACKAGE__->add_columns(
    'chart_id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 11,
        is_auto_increment   => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'chart_type_id', {
        data_type           => 'TINYINT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 4,
        is_foreign_key      => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'chart_axis_type_x_id', {
        data_type           => 'TINYINT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 4,
        is_foreign_key      => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'chart_axis_type_y_id', {
        data_type           => 'TINYINT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 4,
        is_foreign_key      => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'owner_id', {
        data_type           => 'SMALLINT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 6,
        is_foreign_key      => 1,
        extra               => {
            unsigned        => 1,
        },
    },
    'chart_name', {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 0,
        size                => 64,
    },
    'order_by_x_axis', {
        data_type           => 'TINYINT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 4,
        extra               => {
            unsigned => 1,
        },
    },
    'order_by_y_axis', {
        data_type           => 'TINYINT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 4,
        extra               => {
            unsigned => 1,
        },
    },
    'active', {
        data_type           => 'TINYINT',
        default_value       => 0,
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
    'updated_at', {
        data_type           => 'TIMESTAMP',
        default_value       => undef,
        is_nullable         => 1,
    },
);


(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->set_primary_key('chart_id');

__PACKAGE__->belongs_to(
    owner => "${basepkg}::Owner",
    { 'foreign.id'    => 'self.owner_id' },
);
__PACKAGE__->belongs_to(
    chart_type => "${basepkg}::ChartTypes",
    { 'foreign.chart_type_id' => 'self.chart_type_id' },
);
__PACKAGE__->belongs_to(
    chart_axis_type_x  => "${basepkg}::ChartAxisTypes",
    { 'foreign.chart_axis_type_id' => 'self.chart_axis_type_x_id' },
);
__PACKAGE__->belongs_to(
    chart_axis_type_y => "${basepkg}::ChartAxisTypes",
    { 'foreign.chart_axis_type_id' => 'self.chart_axis_type_y_id' },
);
__PACKAGE__->has_many(
    chart_lines => 'Tapper::Schema::TestrunDB::Result::ChartLines',
    { 'foreign.chart_id' => 'self.chart_id' },
);

1;