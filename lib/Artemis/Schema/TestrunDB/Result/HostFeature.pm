package Artemis::Schema::TestrunDB::Result::HostFeature;

use 5.010;
use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table("host_feature");
__PACKAGE__->add_columns
    (
     "id",                        { data_type => "INT",       default_value => undef,                is_nullable => 0, size => 11,    is_auto_increment => 1, },
     "host_id",                   { data_type => "VARCHAR",   default_value => "",                   is_nullable => 1, size => 255,                           },
     "key",                      { data_type => "TINYINT",   default_value => "0",                  is_nullable => 1,                                        },
     "value",                    { data_type => "TINYINT",   default_value => "0",                  is_nullable => 1,                                        },
     "created_at",                { data_type => "TIMESTAMP", default_value => \'CURRENT_TIMESTAMP', is_nullable => 1,                                        }, # '
     "updated_at",                { data_type => "DATETIME",  default_value => undef,                is_nullable => 1,                                        },

    );

__PACKAGE__->set_primary_key("id");

(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->belongs_to ( host => "${basepkg}::Host", { 'foreign.id' => 'self.host_id' });


1;

=head1 NAME

Artemis::Schema::TestrunDB::Result::HostFeature - A ResultSet description


=head1 SYNOPSIS


=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008..2009 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive

