package Tapper::Schema::TestrunDB::Result::TestplanInstance;

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table("testplan_instance");
__PACKAGE__->add_columns
  (
   "id",                 { data_type => "INT",       default_value => undef,                is_nullable => 0, size => 11, is_auto_increment => 1, },
   "path",               { data_type => "VARCHAR",   default_value => "",                   is_nullable => 1, size => 255, },
   "name",               { data_type => "VARCHAR",   default_value => "",                   is_nullable => 1, size => 255, },
   "evaluated_testplan", { data_type => "TEXT",      default_value => "",                   is_nullable => 1, },
   "created_at",         { data_type => "TIMESTAMP", default_value => \'CURRENT_TIMESTAMP', is_nullable => 1, },
   "updated_at",         { data_type => "DATETIME",  default_value => undef,                is_nullable => 1, },
    );

__PACKAGE__->has_many ( testruns => 'Tapper::Schema::TestrunDB::Result::Testrun', { 'foreign.testplan_id' => 'self.id' });
__PACKAGE__->set_primary_key("id");

1;

=head1 NAME

Tapper::Schema::TestrunDB::Testrun - A ResultSet description


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

