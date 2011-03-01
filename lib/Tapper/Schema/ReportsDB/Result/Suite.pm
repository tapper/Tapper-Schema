package Tapper::Schema::ReportsDB::Result::Suite;

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("suite");
__PACKAGE__->add_columns
    (
     "id",          { data_type => "INT",     default_value => undef, is_nullable => 0, size => 11, is_auto_increment => 1, },
     "name",        { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 255,                        },
     "type",        { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 50,                         },
     "description", { data_type => "TEXT",    default_value => undef, is_nullable => 0,                                     },
    );

__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many   ( reports => 'Tapper::Schema::ReportsDB::Result::Report', { 'foreign.suite_id'        => 'self.id' });

sub sqlt_deploy_hook
{
        my ($self, $sqlt_table) = @_;
        $sqlt_table->add_index(name => 'suite_idx_name', fields => ['name']);
}

1;

=head1 NAME

Tapper::Schema::ReportsDB::Result::User - A ResultSet description


=head1 SYNOPSIS

Abstraction for the database table.

 use Tapper::Schema::ReportsDB;


=head1 AUTHOR

AMD OSRC Tapper Team, C<< <tapper at amd64.org> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008-2011 AMD OSRC Tapper Team, all rights reserved.

This program is released under the following license: freebsd

