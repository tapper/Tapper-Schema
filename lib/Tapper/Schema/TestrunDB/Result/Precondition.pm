package Tapper::Schema::TestrunDB::Result::Precondition;

use strict;
use warnings;

use parent 'DBIx::Class';
use YAML::Syck;

__PACKAGE__->load_components("Core");
__PACKAGE__->table("precondition");
__PACKAGE__->add_columns
    (
     "id",                              { data_type => "INT",      default_value => undef, is_nullable => 0, size => 11, is_auto_increment => 1, },
     "shortname",                       { data_type => "VARCHAR",  default_value => "",    is_nullable => 0, size => 255,                        },
     "precondition",                    { data_type => "TEXT",     default_value => undef, is_nullable => 1,                                     },
     "timeout",                         { data_type => "INT",      default_value => undef, is_nullable => 1, size => 10,                         },
    );

__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many     ( child_pre_precondition      => 'Tapper::Schema::TestrunDB::Result::PrePrecondition',     { 'foreign.parent_precondition_id' => 'self.id' });
__PACKAGE__->many_to_many ( child_preconditions         => 'child_pre_precondition',                                  'child' );

__PACKAGE__->has_many     ( parent_pre_precondition     => 'Tapper::Schema::TestrunDB::Result::PrePrecondition',     { 'foreign.child_precondition_id' => 'self.id' });
__PACKAGE__->many_to_many ( parent_preconditions        => 'parent_pre_precondition',                                 'parent' );

__PACKAGE__->has_many     ( testrun_precondition        => 'Tapper::Schema::TestrunDB::Result::TestrunPrecondition', { 'foreign.precondition_id'       => 'self.id' },  { 'join_type' => 'INNER' });
__PACKAGE__->many_to_many ( parent_testruns             => 'testrun_precondition',                                    'testrun' );

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
                        $val = $Tapper::Schema::TestrunDB::NULL;
                }
                $str   .= $val . $Tapper::Schema::TestrunDB::DELIM;
        }
        return $str;
}

sub precondition_as_hash {
        Load(shift->precondition);
}

sub update_content {
        my ($self, $condition) = @_;

        my $yaml_error = Tapper::Schema::TestrunDB::_yaml_ok($condition);
        die Tapper::Exception::Param->new($yaml_error) if $yaml_error;

        my $cond_hash = Load($condition);

        $self->shortname( $cond_hash->{shortname} ) if $cond_hash->{shortname};
        $self->precondition( $condition );
        $self->timeout( $cond_hash->{timeout} ) if $cond_hash->{timeout};
        $self->update;

        return $self->id;
}

=head1 NAME

Tapper::Schema::TestrunDB::Result::Precondition - A ResultSet description


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

