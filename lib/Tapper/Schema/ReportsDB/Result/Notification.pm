package Tapper::Schema::ReportsDB::Result::Notification;

use strict;
use warnings;

use parent 'DBIx::Class';
use YAML::Syck;

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table("notification");
__PACKAGE__->add_columns
    ( "id",         { data_type => "INT",       default_value => undef,                is_nullable => 0, size => 11, is_auto_increment => 1, },
      "user_id ",   { data_type => "INT",       default_value => undef,                is_nullable => 1, size => 11, is_foreign_key    => 1, },
      "persist",    { data_type => "INT",       default_value => undef,                is_nullable => 1, size => 1, },
      "event",      { data_type => "VARCHAR",   default_value => undef,                is_nullable => 0, size => 255, },    # subscribe to this event type
      "check",      { data_type => "VARCHAR",   default_value => undef,                is_nullable => 0, size => 65000, },  # data for check handler
      "created_at", { data_type => "TIMESTAMP", default_value => \'CURRENT_TIMESTAMP', is_nullable => 1, },
      "updated_at", { data_type => "DATETIME",  default_value => undef,                is_nullable => 1, },
    );
 });

(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to( user => "${basepkg}::User", { 'foreign.id' => 'self.user_id' });

=head1 NAME

Tapper::Schema::ReportsDB::Result::Notification - Keep data about notification subscriptions


=head1 SYNOPSIS

Abstraction for the database table.

 use Tapper::Schema::ReportsDB;


=head1 AUTHOR

AMD OSRC Tapper Team, C<< <tapper at amd64.org> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008-2012 AMD OSRC Tapper Team, all rights reserved.

This program is released under the following license: freebsd

=cut

1;
