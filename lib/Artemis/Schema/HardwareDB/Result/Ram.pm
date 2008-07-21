package Artemis::Schema::HardwareDB::Ram;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("ram");
__PACKAGE__->add_columns(
  "lid",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 6,
  },
  "vendor",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "type",
  { data_type => "ENUM", default_value => undef, is_nullable => 1, size => 11 },
  "speed",
  { data_type => "ENUM", default_value => undef, is_nullable => 1, size => 5 },
  "size_mbyte",
  { data_type => "ENUM", default_value => undef, is_nullable => 1, size => 5 },
  "free",
  { data_type => "TINYINT", default_value => 1, is_nullable => 1, size => 1 },
  "abolished",
  { data_type => "TINYINT", default_value => 0, is_nullable => 1, size => 1 },
);
__PACKAGE__->set_primary_key("lid");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-05-22 14:22:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:I0idH96RK6Sfbl/OhNwgDw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
