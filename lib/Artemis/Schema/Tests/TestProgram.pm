package Artemis::Schema::Tests::TestProgram;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("test_program");
__PACKAGE__->add_columns(
  "lid",
  {
    data_type => "MEDIUMINT",
    default_value => undef,
    is_nullable => 0,
    size => 9,
  },
  "name",
  { data_type => "TINYTEXT", default_value => "", is_nullable => 0, size => 255 },
  "path",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "description",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "parameter",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "scm_url",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "scm_rev",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 255 },
  "user",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
);
__PACKAGE__->set_primary_key("lid");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-04-28 17:22:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:eukzpweKykl7hRe2eFgm0Q


# You can replace this text with custom content, and it will be preserved on regeneration
1;
