package Artemis::Schema::Printable;

use strict;
use warnings;

sub to_string
{
        my ($self) = @_;

        return "Implement me. Now!\n";
#         my $format = join( $Artemis::Schema::ReportsDB::DELIM, (qw/%s/ x scalar @{$self->result_source->{_ordered_columns})), '');
#         sprintf (
#                  $format,
#                  map {
#                       defined $self->$_
#                       ? $self->$_
#                       : $Artemis::Schema::ReportsDB::NULL
#                      } @{$self->result_source->{_ordered_columns} }
#                 );
}

1;
