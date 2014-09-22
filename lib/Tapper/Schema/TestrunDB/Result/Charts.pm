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

__PACKAGE__->has_many(
    chart_versions => 'Tapper::Schema::TestrunDB::Result::ChartVersions',
    { 'foreign.chart_id' => 'self.chart_id' },
);
__PACKAGE__->has_many(
    chart_tag_relations => 'Tapper::Schema::TestrunDB::Result::ChartTagRelations',
    { 'foreign.chart_id' => 'self.chart_id' },
);

1;