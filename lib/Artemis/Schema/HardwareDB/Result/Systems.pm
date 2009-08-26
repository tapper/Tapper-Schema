package Artemis::Schema::HardwareDB::Result::Systems;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("systems");
__PACKAGE__->add_columns(
  "lid",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 6,
  },
  "systemname",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "revision_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 6,
  },
  "revision_date",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
    size => 14,
  },
  "scheduled",
  { data_type => "TINYINT", default_value => 0, is_nullable => 0, size => 1 },
  "active",
  { data_type => "TINYINT", default_value => 1, is_nullable => 0, size => 1 },
  "location",
  {
    data_type => "ENUM",
    default_value => "2.4.030",
    is_nullable => 0,
    size => 10,
  },
  "purpose",
  {
    data_type => "ENUM",
    default_value => "Infrastructure",
    is_nullable => 0,
    size => 14,
  },
  "key_word",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "current_owner",
  { data_type => "VARCHAR", default_value => "", is_nullable => 1, size => 255 },

);
__PACKAGE__->set_primary_key("lid");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-05-22 14:22:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8LO4b+LChpwxSvGCeRAu7g

__PACKAGE__->has_many ( revision => 'Artemis::Schema::HardwareDB::Result::Revision', { 'foreign.revision_id' => 'self.revision_id' });

# You can replace this text with custom content, and it will be preserved on regeneration
1;
