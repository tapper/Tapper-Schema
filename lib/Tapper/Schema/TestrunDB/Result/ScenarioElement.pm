package Tapper::Schema::TestrunDB::Result::ScenarioElement;

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
     "is_fitted",   { data_type => "INT", default_value => 0,     is_nullable => 0, size => 1,                           },
    );

__PACKAGE__->set_primary_key(qw/id/);

(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->belongs_to( testrun       => "${basepkg}::Testrun",         { 'foreign.id'  => 'self.testrun_id'            });
__PACKAGE__->belongs_to( scenario      => "${basepkg}::Scenario",        { 'foreign.id'  => 'self.scenario_id'           });
__PACKAGE__->has_many  ( peer_elements => "${basepkg}::ScenarioElement", { 'foreign.scenario_id'   => 'self.scenario_id' });

=head2 peers_need_fitting

Count how many elements of this scenario do not have is_fitted already
set. This count may include $self.

@return int - number of unfitted elements in same scenario

=cut

sub peers_need_fitting
{
        my ($self) = @_;
        return $self->peer_elements->search({is_fitted => { '!=' => 1,}})->count;
}

1;

=head1 NAME

Tapper::Schema::TestrunDB::Result::Testgroup - Grouping of interdependent tests  


=head1 SYNOPSIS

Abstraction for the database table.

 use Tapper::Schema::TestrunDB;


=head1 AUTHOR

AMD OSRC Tapper Team, C<< <tapper at amd64.org> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008-2011 AMD OSRC Tapper Team, all rights reserved.

This program is released under the following license: freebsd

