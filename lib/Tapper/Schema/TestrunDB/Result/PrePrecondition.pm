package Tapper::Schema::TestrunDB::Result::PrePrecondition;

# ABSTRACT: Tapper - Containing nested preconditions

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("pre_precondition");
__PACKAGE__->add_columns
    (
     "parent_precondition_id", { data_type => "INT",      default_value => undef, is_nullable => 0, size => 11, is_foreign_key => 1, },
     "child_precondition_id",  { data_type => "INT",      default_value => undef, is_nullable => 0, size => 11, is_foreign_key => 1, },
     "succession",             { data_type => "INT",      default_value => undef, is_nullable => 0, size => 10,                      },
    );

__PACKAGE__->set_primary_key(qw/parent_precondition_id child_precondition_id/);

__PACKAGE__->belongs_to( parent => 'Tapper::Schema::TestrunDB::Result::Precondition', { 'foreign.id' => 'self.parent_precondition_id' });
__PACKAGE__->belongs_to( child  => 'Tapper::Schema::TestrunDB::Result::Precondition', { 'foreign.id' => 'self.child_precondition_id'  });

1;