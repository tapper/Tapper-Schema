package Tapper::Schema::TestrunDB::Result::State;

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table("state");
__PACKAGE__->add_columns
    ( "id",        { data_type => "INT",       default_value => undef,                is_nullable => 0, size => 11, is_auto_increment => 1, },
     "testrun_id", { data_type => "INT",       default_value => undef,                is_nullable => 0, size => 11, is_foreign_key    => 1, },
     "state",      { data_type => "VARCHAR",   default_value => undef,                is_nullable => 1, size => 65000, },
     "created_at", { data_type => "TIMESTAMP", default_value => \'CURRENT_TIMESTAMP', is_nullable => 1, },
     "updated_at", { data_type => "DATETIME",  default_value => undef,                is_nullable => 1, },
    );
__PACKAGE__->inflate_column( state => {
                                       inflate => sub { YAML::XS::Load(shift) },
                                       deflate => sub { YAML::XS::Dump(shift)},
                                      });


(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint( unique_testrun_id => [ qw/testrun_id/ ], );
__PACKAGE__->belongs_to( testrun => "${basepkg}::Testrun", { 'foreign.id' => 'self.testrun_id' });

=head1 NAME

Tapper::Schema::TestrunDB::Result::State - A ResultSet description


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

=cut

1;
