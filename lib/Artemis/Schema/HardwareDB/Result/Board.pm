package Artemis::Schema::HardwareDB::Result::Board;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("board");
__PACKAGE__->add_columns(
  "lid",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 6,
  },
  "id_system",
  { data_type => "SMALLINT", default_value => "", is_nullable => 0, size => 6 },
  "manufacturer",
  {
    data_type => "TINYTEXT",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "type",
  { data_type => "TINYTEXT", default_value => "", is_nullable => 0, size => 255 },
  "socket_type",
  { data_type => "ENUM", default_value => "", is_nullable => 0, size => 3 },
  "nbridge",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 255 },
  "sbridge",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 255 },
  "numsock",
  { data_type => "TINYINT", default_value => undef, is_nullable => 1, size => 3 },
);
__PACKAGE__->set_primary_key("lid");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-05-22 14:21:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xsAvHUaGrcUXdTCGBTHNYQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
