package Tapper::Schema::TestrunDB::Result::Scenario;

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

