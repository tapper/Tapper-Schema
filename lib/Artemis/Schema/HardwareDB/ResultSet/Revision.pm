package Artemis::Schema::HardwareDB::ResultSet::Revision;

use strict;
use warnings;

use DateTime;


use parent 'DBIx::Class::ResultSet';


___END___

# just an idea on how to implement this, don't want to throw it away

sub cpu_array
{
        my ($self) = @_;
        my $cpu_revision_rs = $self->search({component_type => 'cpu'});
        my @resultset;
        foreach my $cpu ($cpu_revision_rs->next) {
                push @resultset, $self->result_source->schema->resultset('Cpu')->find($cpu->component_id);
        }
        return @resultset;
}
