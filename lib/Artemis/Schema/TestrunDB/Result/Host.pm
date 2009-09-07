package Artemis::Schema::TestrunDB::Result::Host;

use 5.010;
use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table("host");
__PACKAGE__->add_columns
    (
     "id",                        { data_type => "INT",       default_value => undef,                is_nullable => 0, size => 11,    is_auto_increment => 1, },
     "name",                      { data_type => "VARCHAR",   default_value => "",                   is_nullable => 1, size => 255,                           },
     "allowed_context",           { data_type => "VARCHAR",   default_value => "",                   is_nullable => 1, size => 255,                           }, # "live", "development", "test", ""/NULL
     "busy",                      { data_type => "VARCHAR",   default_value => "",                   is_nullable => 1, size => 255,                           },
     "created_at",                { data_type => "TIMESTAMP", default_value => \'CURRENT_TIMESTAMP', is_nullable => 1,                                        }, # '
     "updated_at",                { data_type => "DATETIME",  default_value => undef,                is_nullable => 1,                                        },

     # the host's feature set is read dynamically from HardwareDB inside application

    );

__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many ( testrunschedulings => 'Artemis::Schema::TestrunDB::Result::TestrunScheduling', { 'foreign.host_id' => 'self.id' });

1;

=head1 NAME

Artemis::Schema::TestrunDB::Testrun - A ResultSet description


=head1 SYNOPSIS

Abstraction for the database table.

 use Artemis::Schema::TestrunDB;


=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008..2009 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive

