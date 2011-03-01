package Tapper::Schema::TestrunDB::Result::Topic;

use strict;
use warnings;

our %topic_description =
    (
     Kernel       => 'particlar kernel version or kernel modules',
     Xen          => 'Xen features',
     KVM          => 'KVM features',
     Hardware     => 'test focuses on the hardware',
     Distribution => 'OS distribution (like RHEL, SLES, Debian)',
     Benchmark    => 'collection of values',
     Software     => 'any non-kernel software, like libraries, programs',
     Research     => 'collection of results, similar to benchmark',
     Misc         => 'what does not fit into other topics',
    );

use parent 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("topic");
__PACKAGE__->add_columns
    (
     "name",        { data_type => "VARCHAR",  default_value => undef, is_nullable => 0, size => 255     },
     "description", { data_type => "TEXT",     default_value => "",    is_nullable => 0,                },
    );
__PACKAGE__->set_primary_key("name");


1;

=head1 NAME

Tapper::Schema::TestsDB::Topic - A ResultSet description


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

