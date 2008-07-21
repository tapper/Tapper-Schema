package Artemis::Schema::HardwareDB::Misc;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("misc");
__PACKAGE__->add_columns(
  "lid",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 6,
  },
  "vendor",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "type",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "information",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "free",
  { data_type => "VARCHAR", default_value => 1, is_nullable => 0, size => 1 },
  "abolished",
  { data_type => "VARCHAR", default_value => 0, is_nullable => 0, size => 1 },
);
__PACKAGE__->set_primary_key("lid");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-05-22 14:22:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:B0eSk7N5F4CuKCmPf8mqaw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
