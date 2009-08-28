package Artemis::Schema::TestrunDB::Result::TestrunRequestedFeature;

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("testrun_requested_feature");
__PACKAGE__->add_columns
    (
     "id",              { data_type => "INT",     default_value => undef, is_nullable => 0, size => 11, is_auto_increment => 1, },
     "testrun_id",      { data_type => "INT",     default_value => undef, is_nullable => 0, size => 11, is_foreign_key    => 1, },
     "feature",         { data_type => "VARCHAR", default_value => "",    is_nullable => 1, size => 255,                        },
    );

__PACKAGE__->set_primary_key(qw/id testrun_id/);

__PACKAGE__->belongs_to( testrun => 'Artemis::Schema::TestrunDB::Result::Testrun', { 'foreign.id' => 'self.testrun_id' });

1;

=head1 NAME

Artemis::Schema::TestrunDB::Result::PrePrecondition - A ResultSet description


=head1 SYNOPSIS

Abstraction for the database table.

 use Artemis::Schema::TestrunDB;


=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive

