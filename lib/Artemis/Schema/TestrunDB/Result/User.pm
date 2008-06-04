package Artemis::Schema::TestrunDB::Result::User;

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("user");
__PACKAGE__->add_columns
    (
     "id",       { data_type => "INT",     default_value => undef, is_nullable => 0, size => 11     },
     "name",     { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 255    },
     "login",    { data_type => "VARCHAR", default_value => undef, is_nullable => 0, size => 255    },
     "password", { data_type => "VARCHAR", default_value => undef, is_nullable => 1, size => 255    },
    );
__PACKAGE__->set_primary_key("id");

1;

=head1 NAME

Artemis::Schema::TestrunDB::Result::User - A ResultSet description


=head1 SYNOPSIS

Abstraction for the database table.

 use Artemis::Schema::TestrunDB;


=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive

