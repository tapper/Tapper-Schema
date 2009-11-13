package Artemis::Schema::TestrunDB::Result::Scenario;

use 5.010;
use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::Object::Enum", "Core");
__PACKAGE__->table("scenario");
__PACKAGE__->add_columns
    (
     "id",   { data_type => "INT",       default_value => undef, is_nullable => 0, size => 11,  is_auto_increment => 1, },
     "type", { data_type => "VARCHAR",   default_value => "",    is_nullable => 0, size => 255,                         },
    );

__PACKAGE__->set_primary_key(qw/id/);

(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->has_many  ( scenario_elements => "${basepkg}::ScenarioElement", { 'foreign.scenario_id'   => 'self.id' });


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

