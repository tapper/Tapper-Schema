package Artemis::Schema::TestrunDB::ResultSet::Queue;

use 5.010;
use strict;
use warnings;

use parent 'DBIx::Class::ResultSet';
use Data::Dumper;

sub official_queuelist {
        my ($self) = @_;

        my %queues;
        while (my $q = $self->next) {
                my %producer;
                print STDERR "* name: ", Dumper($q->name);
                $queues{$q->name} = $q;
        }
        return \%queues;
}

1;
