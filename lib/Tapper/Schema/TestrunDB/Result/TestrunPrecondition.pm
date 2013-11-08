package Tapper::Schema::TestrunDB::Result::TestrunPrecondition;

# ABSTRACT: Tapper - Containg relations between testruns and preconditions

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("testrun_precondition");
__PACKAGE__->add_columns
    (
     "testrun_id",      { data_type => "INT", default_value => undef, is_nullable => 0, size => 11, is_foreign_key => 1, },
     "precondition_id", { data_type => "INT", default_value => undef, is_nullable => 0, size => 11, is_foreign_key => 1, },
     "succession",      { data_type => "INT", default_value => undef, is_nullable => 1, size => 10,                      },
    );

__PACKAGE__->set_primary_key(qw/testrun_id precondition_id/);

__PACKAGE__->belongs_to( testrun       => 'Tapper::Schema::TestrunDB::Result::Testrun',      { 'foreign.id' => 'self.testrun_id'      });
__PACKAGE__->belongs_to( precondition  => 'Tapper::Schema::TestrunDB::Result::Precondition', { 'foreign.id' => 'self.precondition_id' });

1;