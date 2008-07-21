package Artemis::Schema::HardwareDB::Mainboard;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("mainboard");
__PACKAGE__->add_columns(
  "lid",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 6,
  },
  "vendor",
  { data_type => "TINYTEXT", default_value => "", is_nullable => 0, size => 255 },
  "model",
  {
    data_type => "TINYTEXT",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "socket_type",
  { data_type => "ENUM", default_value => "", is_nullable => 0, size => 6 },
  "nbridge",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "sbridge",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "num_cpu_sock",
  { data_type => "TINYINT", default_value => 1, is_nullable => 0, size => 3 },
  "num_ram_sock",
  { data_type => "TINYINT", default_value => 4, is_nullable => 0, size => 8 },
  "bios",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "features",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "free",
  { data_type => "TINYINT", default_value => 1, is_nullable => 0, size => 1 },
  "abolished",
  { data_type => "TINYINT", default_value => 0, is_nullable => 0, size => 1 },
);
__PACKAGE__->set_primary_key("lid");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-05-22 14:22:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:loXH39TsxNsg8E/mb4YGdw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
