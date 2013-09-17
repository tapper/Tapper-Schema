package Tapper::Schema::TestrunDB::Result::NotificationEvent;

use strict;
use warnings;

use parent 'DBIx::Class';
use YAML::Syck;

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core InflateColumn/);
__PACKAGE__->table("notification_event");
__PACKAGE__->add_columns
    ( "id",         { data_type => "INT",       default_value => undef,                is_nullable => 0, size => 11, is_auto_increment => 1, },
      "message",    { data_type => "VARCHAR",   default_value => undef, size => 255,                is_nullable => 1, },
      "type",       { data_type => "VARCHAR",   is_nullable => 1, size => 255, is_enum => 1, extra => { list => [qw(testrun_finished report_received)] } },
      "created_at", { data_type => "TIMESTAMP", default_value => \'CURRENT_TIMESTAMP', is_nullable => 1, },
      "updated_at", { data_type => "DATETIME",  default_value => undef,                is_nullable => 1, },
    );

(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->inflate_column( message => {
                                        inflate => sub { Load(shift) },
                                        deflate => sub { Dump(shift)},
 });


__PACKAGE__->set_primary_key("id");

=head1 NAME

Tapper::Schema::TestrunDB::Result::NotificationEvent - Keep data about events that may trigger notifications


=head1 SYNOPSIS

Abstraction for the database table.

 use Tapper::Schema::TestrunDB;


=head1 AUTHOR

AMD OSRC Tapper Team, C<< <tapper at amd64.org> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008-2012 AMD OSRC Tapper Team, all rights reserved.

This program is released under the following license: freebsd

=cut

1;
