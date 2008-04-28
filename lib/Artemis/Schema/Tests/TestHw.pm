package Artemis::Schema::Tests::TestHw;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("test_hw");
__PACKAGE__->add_columns(
  "id_testrun",
  { data_type => "MEDIUMINT", default_value => "", is_nullable => 0, size => 9 },
  "id_hw",
  { data_type => "MEDIUMINT", default_value => "", is_nullable => 0, size => 9 },
);
__PACKAGE__->set_primary_key("id_testrun");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-04-28 17:22:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VoHtFUkxsUvwgNLfNHFQgA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
