package Tapper::Schema::TestrunDB::Result::TestrunRequestedResource;

# ABSTRACT: Tapper - Relate testruns with list of resource alternatives ( requested )

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("testrun_requested_resource");
__PACKAGE__->add_columns
    (
     "id",              { data_type => "INT",     default_value => undef, is_nullable => 0, size => 11, is_auto_increment => 1, },
     "testrun_id",      { data_type => "INT",     default_value => undef, is_nullable => 0, size => 11, is_foreign_key    => 1, },
     "selected_resource_id", { data_type => "INT",     default_value => undef, is_nullable => 1, size => 11, is_foreign_key    => 1, }
    );

__PACKAGE__->set_primary_key(qw/id/);

(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->belongs_to( testrunscheduling => "${basepkg}::Testrun", { 'foreign.id' => 'self.testrun_id' });

__PACKAGE__->has_many(
    alternatives => "${basepkg}::TestrunRequestedResourceAlternative",
    { 'foreign.request_id' => 'self.id' },
  );

__PACKAGE__->belongs_to(
    selected_resource => "${basepkg}::Resource",
    { 'foreign.id' => 'self.selected_resource_id' },
    { join_type => 'left', on_delete => 'SET NULL' },
);
1;
