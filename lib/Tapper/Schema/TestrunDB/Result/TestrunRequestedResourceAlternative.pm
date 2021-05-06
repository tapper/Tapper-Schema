package Tapper::Schema::TestrunDB::Result::TestrunRequestedResourceAlternative;

# ABSTRACT: Tapper - Relate testruns with resource ( requested )

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("testrun_requested_resource_alternative");
__PACKAGE__->add_columns
    (
     "id",              { data_type => "INT",     default_value => undef, is_nullable => 0, size => 11, is_auto_increment => 1, },
     "request_id",      { data_type => "INT",     is_nullable => 0, size => 11, is_foreign_key    => 1, },
     "resource_id",      { data_type => "INT",     is_nullable => 0, size => 11, is_foreign_key    => 1, },
    );

__PACKAGE__->set_primary_key(qw/id/);

(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->belongs_to(
    resource => "${basepkg}::Resource",
    { 'foreign.id' => 'self.resource_id' },
    { on_delete => 'CASCADE' },
);

__PACKAGE__->belongs_to(
    request => "${basepkg}::TestrunRequestedResource",
    { 'foreign.id' => 'self.request_id' },
);
1;
