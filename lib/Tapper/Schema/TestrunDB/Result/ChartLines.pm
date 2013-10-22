package Tapper::Schema::TestrunDB::Result::ChartLines;

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/FilterColumn InflateColumn::DateTime Core/);
__PACKAGE__->table('chart_lines');
__PACKAGE__->add_columns(
    'chart_line_id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 11,
        is_auto_increment   => 1,
        extra               => {
            unsigned => 1,
        },
    },
    'chart_id', {
        data_type           => 'INT',
        default_value       => undef,
        is_nullable         => 0,
        size                => 11,
        is_foreign_key      => 1,
        extra               => {
            unsigned        => 1,
        },
    },
    'chart_axis_x_column'   , {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 0,
        size                => 64,
    },
    'chart_axis_x_column_format'   , {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 0,
        size                => 64,
    },
    'chart_axis_y_column'   , {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 0,
        size                => 64,
    },
    'chart_axis_y_column_format'   , {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 0,
        size                => 64,
    },
    'chart_line_name'   , {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 0,
        size                => 64,
    },
    'chart_line_statement'   , {
        data_type           => 'VARCHAR',
        default_value       => undef,
        is_nullable         => 0,
        size                => 1024,
    },
    'created_at', {
        data_type           => 'TIMESTAMP',
        default_value       => undef,
        is_nullable         => 0,
        set_on_create       => 1,
    },
);


(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->set_primary_key('chart_line_id');
__PACKAGE__->filter_column('chart_line_statement', {
    filter_from_storage => sub {
        my ($row, $element) = @_;
        require JSON::XS;
        return JSON::XS::decode_json( $element );
    },
    filter_to_storage => sub {
        my ($row, $element) = @_;
        require JSON::XS;
        return JSON::XS::encode_json( $element );
    },
});
__PACKAGE__->belongs_to(
    chart => "${basepkg}::Charts",
    { 'foreign.chart_id' => 'self.chart_id' },
);
__PACKAGE__->has_many(
    chart_additionals => "${basepkg}::ChartLineAdditionals",
    { 'foreign.chart_line_id' => 'self.chart_line_id' },
);

=head1 NAME

Tapper::Schema::TestrunDB::Result::ChartLines - Keep Chart Lines for Charts


=head1 SYNOPSIS

Abstraction for the database table.

 use Tapper::Schema::TestrunDB;


=head1 AUTHOR

AMD OSRC Tapper Team, C<< <tapper at amd64.org> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008-2012 AMD OSRC Tapper Team, all rights reserved.

This program is released under the following license: freebsd

=cut

1;