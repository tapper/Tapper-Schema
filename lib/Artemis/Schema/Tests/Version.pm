package Artemis::Schema::Tests::Version;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("version");
__PACKAGE__->add_columns(
  "version",
  { data_type => "INT", default_value => "", is_nullable => 0, size => 10 },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-04-28 17:22:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:brYpMFgfDdSEBSm7EiwcNw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
