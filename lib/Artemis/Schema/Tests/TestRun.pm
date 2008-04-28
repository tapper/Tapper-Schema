package Artemis::Schema::Tests::TestRun;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("test_run");
__PACKAGE__->add_columns(
  "lid",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "description",
  { data_type => "TEXT", default_value => "", is_nullable => 0, size => 65535 },
  "stime_req",
  { data_type => "INT", default_value => "", is_nullable => 0, size => 10 },
  "stime_actual",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 10 },
  "etime",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 10 },
  "journal",
  { data_type => "ENUM", default_value => undef, is_nullable => 1, size => 12 },
  "hw_id",
  { data_type => "SMALLINT", default_value => "", is_nullable => 0, size => 5 },
  "kopt",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "user",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 8 },
  "user_notify_mail",
  { data_type => "TINYINT", default_value => undef, is_nullable => 1, size => 1 },
  "user_notify_xmpp",
  { data_type => "TINYINT", default_value => undef, is_nullable => 1, size => 1 },
  "boot_return_value",
  { data_type => "TINYINT", default_value => undef, is_nullable => 1, size => 4 },
  "boot_return_value_desc",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "wait_after_tests",
  { data_type => "ENUM", default_value => "no", is_nullable => 1, size => 10 },
);
__PACKAGE__->set_primary_key("lid");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-04-28 17:22:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Y7aICrE54ChnNSBE+prHiQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
