package Tapper::Schema::TestrunDB::Result::Notification;

use strict;
use warnings;

use parent 'DBIx::Class';
use YAML::Syck;

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table("notification");
__PACKAGE__->add_columns
    ( "id",         { data_type => "INT",       default_value => undef,                is_nullable => 0, size => 11, is_auto_increment => 1, },
      "owner_id",   { data_type => "INT",       default_value => undef,                is_nullable => 1, size => 11, is_foreign_key    => 1, extra => { renamed_from => 'user_id'  }, },
      "persist",    { data_type => "INT",       default_value => undef,                is_nullable => 1, size => 1, },
      "event",      { data_type => "VARCHAR",   default_value => undef,                is_nullable => 0, size => 255, },    # subscribe to this event type
      "filter",     { data_type => "TEXT",      default_value => undef,                is_nullable => 0,  },  # data for check handler
      "comment",    { data_type => "VARCHAR",   default_value => undef,                is_nullable => 1, size => 255, },    # what shall we send
      "created_at", { data_type => "TIMESTAMP", default_value => \'CURRENT_TIMESTAMP', is_nullable => 1, },
      "updated_at", { data_type => "DATETIME",  default_value => undef,                is_nullable => 1, },
    );

(my $basepkg = __PACKAGE__) =~ s/::\w+$//;

__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to( owner => "${basepkg}::Owner", { 'foreign.id' => 'self.owner_id' });

=head1 NAME

Tapper::Schema::TestrunDB::Result::Notification - Keep data about notification subscriptions


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
