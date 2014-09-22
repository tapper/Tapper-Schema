package Tapper::Schema::TestrunDB::Result::ChartTinyUrls;

# ABSTRACT: Tapper - Keep static Chart Url's for Tapper-Reports-Web-GUI

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table('chart_tiny_urls');
__PACKAGE__->add_columns(
    'chart_tiny_url_id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 12,
        is_auto_increment   => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'visit_count', {
        data_type           => 'INT',
        default_value       => 0,
        is_nullable         => 0,
        size                => 12,
        extra               => {
            unsigned => 1,
        },
    },
    'last_visited', {
        data_type           => 'TIMESTAMP',
        default_value       => undef,
        is_nullable         => 1,
    },
    'created_at', {
        data_type           => 'TIMESTAMP',
        default_value       => undef,
        is_nullable         => 0,
        set_on_create       => 1,
    },
);

(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->set_primary_key('chart_tiny_url_id');

__PACKAGE__->has_many (
    chart_tiny_url_line => "${basepkg}::ChartTinyUrlLines", { 'foreign.chart_tiny_url_id' => 'self.chart_tiny_url_id' },
);


1;
