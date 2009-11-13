package Artemis::Schema::TestrunDB::Result::ScenarioElement;

use 5.010;
use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::Object::Enum", "Core");
__PACKAGE__->table("scenario_element");
__PACKAGE__->add_columns
    (
     "id",          { data_type => "INT", default_value => undef, is_nullable => 0, size => 11,  is_auto_increment => 1, },
     "testrun_id",  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11,  is_foreign_key => 1,    },
     "scenario_id", { data_type => "INT", default_value => undef, is_nullable => 0, size => 11,  is_foreign_key => 1,    },
     "is_fitted",   { data_type => "INT", default_value => 0,     is_nullable => 1, size => 1,                           },
    );

__PACKAGE__->set_primary_key(qw/id/);

(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->belongs_to( testrun           => "${basepkg}::Testrun",         { 'foreign.id'  => 'self.testrun_id'            });
__PACKAGE__->belongs_to( scenario          => "${basepkg}::Scenario",        { 'foreign.id'  => 'self.scenario_id'           });
__PACKAGE__->has_many  ( scenario_elements => "${basepkg}::ScenarioElement", { 'foreign.scenario_id'   => 'self.scenario_id' });


1;

=head1 NAME

Artemis::Schema::TestrunDB::Result::Testgroup - Grouping of interdependent tests  


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

