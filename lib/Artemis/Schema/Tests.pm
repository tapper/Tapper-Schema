package Artemis::Schema::Tests;

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_classes;

__PACKAGE__->connection([ "dbi:mysql:dbname=testsystem;host=alzey", "root", "xyzxyzaa" ]);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-04-28 17:22:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KPn7WC57JfwYQ0uj5H3b/A


# You can replace this text with custom content, and it will be preserved on regeneration
1;
