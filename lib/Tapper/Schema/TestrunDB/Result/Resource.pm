package Tapper::Schema::TestrunDB::Result::Resource;

# ABSTRACT: Resource - abstract resource
# Multiple testruns cannot be scheduled at the same time
# if they require the same resource.

use 5.010;
use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table("resource");
__PACKAGE__->add_columns
  (
    id => {
      data_type => "INT",
      default_value => undef,
      is_nullable => 0,
      size => 11,
      is_auto_increment => 1,
    },
    name => {
      data_type => "VARCHAR",
      default_value => "",
      is_nullable => 1,
      size => 255,
    },
    comment => {
      data_type => "VARCHAR",
      default_value => "",
      is_nullable => 1,
      size => 255,
    },
    active => {
      data_type => "TINYINT",
      default_value => "0",
      is_nullable => 0,
    },
    used_by_scheduling_id => {
      data_type => "INT",
      default_value => undef,
      is_nullable => 1,
      size => 11,
      is_foreign_key => 1,
    },
    created_at => {
      data_type => "TIMESTAMP",
      default_value => \'CURRENT_TIMESTAMP',
      is_nullable => 1,
    },
    updated_at => {
      data_type => "DATETIME",
      default_value => undef,
      is_nullable => 1,
    },
  );

__PACKAGE__->set_primary_key("id");

(my $basepkg = __PACKAGE__) =~ s/::\w+$//;
__PACKAGE__->add_unique_constraint( constraint_name => [ qw/name/ ] );

__PACKAGE__->belongs_to(
  used_by_scheduling => "${basepkg}::TestrunScheduling",
  { 'foreign.id' => 'self.used_by_scheduling_id' },
  { join_type => 'left', on_delete => 'SET NULL' },
);
