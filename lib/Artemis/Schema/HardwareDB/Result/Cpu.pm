package Artemis::Schema::HardwareDB::Result::Cpu;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("cpu");
__PACKAGE__->add_columns(
  "lid",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 6,
  },
  "vendor",
  { data_type => "ENUM", default_value => "AMD", is_nullable => 0, size => 5 },
  "family",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 6,
  },
  "model",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 6,
  },
  "stepping",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 6,
  },
  "revision",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
  "socket_type",
  { data_type => "ENUM", default_value => undef, is_nullable => 1, size => 6 },
  "cores",
  { data_type => "ENUM", default_value => undef, is_nullable => 1, size => 1 },
  "clock",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 6,
  },
  "hasamdv",
  { data_type => "TINYINT", default_value => 1, is_nullable => 0, size => 1 },
  "hasnp",
  { data_type => "TINYINT", default_value => undef, is_nullable => 1, size => 1 },
  "l2cache",
  { data_type => "ENUM", default_value => undef, is_nullable => 1, size => 4 },
  "l3cache",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 10 },
  "free",
  { data_type => "TINYINT", default_value => 1, is_nullable => 0, size => 1 },
  "abolished",
  { data_type => "TINYINT", default_value => 0, is_nullable => 1, size => 1 },
);
__PACKAGE__->set_primary_key("lid");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-05-22 14:22:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0FNvmufcgpw3UqTZQO99xw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
