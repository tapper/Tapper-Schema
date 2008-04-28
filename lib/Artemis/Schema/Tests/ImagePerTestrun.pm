package Artemis::Schema::Tests::ImagePerTestrun;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("image_per_testrun");
__PACKAGE__->add_columns(
  "lid",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "id_testrun",
  { data_type => "MEDIUMINT", default_value => "", is_nullable => 0, size => 9 },
  "path",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "partition",
  {
    data_type => "VARCHAR",
    default_value => "testing",
    is_nullable => 1,
    size => 255,
  },
);
__PACKAGE__->set_primary_key("lid");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-04-28 17:22:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EsrfKenLj2swyTveQODkZA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
