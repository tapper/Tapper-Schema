package Artemis::Schema::HardwareDB::ResultSet::Revision;

use strict;
use warnings;

use DateTime;


use parent 'DBIx::Class::ResultSet';


# (XXX) do it with joins
sub cpus       { shift->_component('cpu')        }
sub rams       { shift->_component('ram')        }
sub mainbords  { shift->_component('mainboard')  }
sub hdds       { shift->_component('hdd')        }
sub graphics   { shift->_component('graphic')    }
sub networks   { shift->_component('network')    }
sub miscs      { shift->_component('misc')       }

sub mem {
        my $size = 0;
        $size   += $_ foreach map {$_->size_mbyte} shift->rams;
        return $size;
}

sub _component
{
        my ($self, $type) = @_;

        my $revision_rs = $self->search({component_type => $type});
        my @component_ids;
        while ( my $component = $revision_rs->next) {
                push @component_ids, {lid => $component->component_id};
        }
        my $search_params = { -or => \@component_ids };
        return $self->result_source->schema->resultset(ucfirst($type))->search( $search_params);
}

1;
