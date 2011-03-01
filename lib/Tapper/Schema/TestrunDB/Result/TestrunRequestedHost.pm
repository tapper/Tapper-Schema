package Tapper::Schema::TestrunDB::Result::TestrunRequestedHost;

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("testrun_requested_host");
__PACKAGE__->add_columns
    (
     "id",              { data_type => "INT",     default_value => undef, is_nullable => 0, size => 11, is_auto_increment => 1, },
     "testrun_id",      { data_type => "INT",     default_value => undef, is_nullable => 0, size => 11, is_foreign_key    => 1, },
     "host_id",         { data_type => "INT",     default_value => undef,    is_nullable => 1,                                     },
    );

__PACKAGE__->set_primary_key(qw/id/);

(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->belongs_to( testrunscheduling => "${basepkg}::Testrun", { 'foreign.id' => 'self.testrun_id' });
__PACKAGE__->belongs_to( host              => "${basepkg}::Host",    { 'foreign.id' => 'self.host_id'    });

1;

=head1 NAME

Tapper::Schema::TestrunDB::Result::PrePrecondition - A ResultSet description


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

