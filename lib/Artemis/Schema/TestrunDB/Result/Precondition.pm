package Artemis::Schema::TestrunDB::Result::Precondition;

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("precondition");
__PACKAGE__->add_columns
    (
     "id",                              { data_type => "INT",      default_value => undef, is_nullable => 0, size => 11                        },
     "shortname",                       { data_type => "VARCHAR",  default_value => "",    is_nullable => 0, size => 255                       },
     "type",                            { data_type => "VARCHAR",  default_value => "",    is_nullable => 0, size => 50,   is_foreign_key => 1 },
     "condition",                       { data_type => "TEXT",     default_value => undef, is_nullable => 1, size => 65535                     },
     "timeout",                         { data_type => "INT",      default_value => undef, is_nullable => 1, size => 10                        },
    );

__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many     ( child_pre_precondition      => 'Artemis::Schema::TestrunDB::Result::PrePrecondition',     { 'foreign.parent_precondition_id' => 'self.id' });
__PACKAGE__->many_to_many ( child_preconditions         => 'child_pre_precondition',                          'child' );

__PACKAGE__->has_many     ( parent_pre_precondition     => 'Artemis::Schema::TestrunDB::Result::PrePrecondition',     { 'foreign.child_precondition_id' => 'self.id' });
__PACKAGE__->many_to_many ( parent_preconditions        => 'parent_pre_precondition',                         'parent' );

__PACKAGE__->has_many     ( testrun_precondition        => 'Artemis::Schema::TestrunDB::Result::TestrunPrecondition', { 'foreign.precondition_id'       => 'self.id' });
__PACKAGE__->many_to_many ( parent_testruns             => 'testrun_precondition',                            'testrun' );

__PACKAGE__->might_have   ( parent_testrun_precondition => 'Artemis::Schema::TestrunDB::Result::TestrunPrecondition', { 'foreign.precondition_id'       => 'self.id' });
__PACKAGE__->belongs_to   ( preconditiontype            => 'Artemis::Schema::TestrunDB::Result::Preconditiontype',    { 'foreign.name'                  => 'self.preconditiontype_name' });

1;

# -------------------- methods in results --------------------

# make a string with newlines to one line inserting \n
sub one_line {
        my ($str) = @_;

        $str =~ s/\\/\\\\/msg;
        $str =~ s/\n/\\n/msg;
        $str;
}

sub quote {
        my ($str) = @_;

        my $d = Data::Dumper->new([$str])->Terse(1)->Indent(0);
        $d->Dump;
}

sub quote_and_one_line {
        my ($str) = @_;

        $str = quote($str);
        $str =~ s/\n/\\n/msg;
        $str;
}

sub to_string
{
        my ($self, $opt) = @_;

        my $str = '';
        foreach (@{$self->result_source->{_ordered_columns} })
        {
                my $val = $self->$_;
                if (defined $val)
                {
                        if ( $opt->{quotevalues} && $opt->{nonewlines} ) {
                                $val = quote_and_one_line($val);
                        } else {
                                $val    = quote($val)    if $opt->{quotevalues};
                                $val    = one_line($val) if $opt->{nonewlines};
                        }
                } else
                {
                        $val = $Artemis::Schema::TestrunDB::NULL;
                }
                $str   .= $val . $Artemis::Schema::TestrunDB::DELIM;
        }
        return $str;
}


=head1 NAME

Artemis::Schema::TestrunDB::Result::Precondition - A ResultSet description


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

