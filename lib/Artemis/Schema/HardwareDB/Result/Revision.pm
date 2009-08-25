package Artemis::Schema::HardwareDB::Result::Revision;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("revision");
__PACKAGE__->add_columns(
  "lid",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 0,
    size => 6,
  },
  "revision_id",
  { data_type => "SMALLINT", default_value => "", is_nullable => 0, size => 6 },
  "component_type",
  { data_type => "ENUM", default_value => undef, is_nullable => 1, size => 9 },
  "component_id",
  {
    data_type => "SMALLINT",
    default_value => undef,
    is_nullable => 1,
    size => 6,
  },
);
__PACKAGE__->set_primary_key("lid");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-05-22 14:22:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3mNIsy5Qoou9679sUbwnYw

__PACKAGE__->has_many     ( cpu       => 'Artemis::Schema::HardwareDB::Result::Cpu',       [ { 'foreign.lid' => 'self.component_id' }, { component => 'cpu' }]);
__PACKAGE__->has_many     ( mainboard => 'Artemis::Schema::HardwareDB::Result::Mainboard', [ { 'foreign.lid' => 'self.component_id' }, { component => 'mainboard' }]);

# You can replace this text with custom content, and it will be preserved on regeneration
1;
