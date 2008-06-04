package Artemis::Schema::TestrunDB::Result::Testrun;

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("testrun");
__PACKAGE__->add_columns
    (
     "id",                        { data_type => "INT",      default_value => undef,  is_nullable => 0, size => 11     },
     "shortname",                 { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 255    },
     "notes",                     { data_type => "TEXT",     default_value => "",     is_nullable => 1, size => 65535  },
     "topic_name",                { data_type => "VARCHAR",  default_value => "",     is_nullable => 0, size => 20, is_foreign_key => 1 },
     "starttime_earliest",        { data_type => "DATETIME", default_value => undef,  is_nullable => 1, size => 19     },
     "starttime_testrun",         { data_type => "DATETIME", default_value => undef,  is_nullable => 1, size => 19     },
     "starttime_test_program",    { data_type => "DATETIME", default_value => undef,  is_nullable => 1, size => 19     },
     "endtime_test_program",      { data_type => "DATETIME", default_value => undef,  is_nullable => 1, size => 19     },
     "hardwaredb_systems_id",     { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 11     },
     "owner_user_id",             { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 11     },
     "test_program",              { data_type => "VARCHAR",  default_value => "",     is_nullable => 0, size => 255    },
     "timeout_after_testprogram", { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10     },
     "wait_after_tests",          { data_type => "INT",      default_value => 0,      is_nullable => 1, size => 1      },
     "created_at",                { data_type => "DATETIME", default_value => undef,  is_nullable => 1, size => 19     },
     "updated_at",                { data_type => "DATETIME", default_value => undef,  is_nullable => 1, size => 19     },
    );

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to( topic => 'Artemis::Schema::TestrunDB::Result::Topic', { 'foreign.name' => 'self.topic_name' });
__PACKAGE__->belongs_to( owner => 'Artemis::Schema::TestrunDB::Result::User',  { 'foreign.id'   => 'self.owner_user_id' });

__PACKAGE__->has_many     ( testrun_precondition => 'Artemis::Schema::TestrunDB::Result::TestrunPrecondition', { 'foreign.testrun_id' => 'self.id' });
__PACKAGE__->many_to_many ( preconditions        => 'testrun_precondition', 'precondition' );


# -------------------- methods on results --------------------

sub to_string
{
        my ($self) = @_;

        my $format = join( $Artemis::Schema::TestrunDB::DELIM, qw/%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s /, '');
        sprintf (
                 $format,
                 map {
                      defined $self->$_
                      ? $self->$_
                      : $Artemis::Schema::TestrunDB::NULL
                     } @{$self->result_source->{_ordered_columns} }
                );
}

=head2 is_member($head, @tail)

Checks if the first element is already in the list of the remaining
elements.

=cut

sub is_member
{
        my ($head, @tail) = @_;
        grep { $head->id eq $_->id } @tail;
}

=head2 ordered_preconditions

Returns all preconditions in the order they need to be installed.

=cut

sub ordered_preconditions
{
        my ($self) = @_;

        my @done = ();
        my %seen = ();
        my @todo = ();

        @todo = $self->preconditions->search({}, {order_by => 'succession'})->all;

        while (my $head = shift @todo)
        {
                if ($seen{$head->id})
                {
                        push @done, $head unless is_member($head, @done);
                }
                else
                {
                        $seen{$head->id} = 1;
                        my @pre_todo = $head->child_preconditions->search({}, { order_by => 'succession' } )->all;
                        unshift @todo, @pre_todo, $head;
                }
        }
        return @done;
}


1;

=head1 NAME

Artemis::Schema::TestrunDB::Testrun - A ResultSet description


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

