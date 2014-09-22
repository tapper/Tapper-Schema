package Tapper::Schema::TestrunDB::Result::ReportFile;

# ABSTRACT: Tapper - Containg files attached to reports

use strict;
use warnings;

use parent 'DBIx::Class';
use Compress::Bzip2;

__PACKAGE__->load_components(qw/FilterColumn InflateColumn::DateTime TimeStamp Core/);
__PACKAGE__->table("reportfile");
__PACKAGE__->add_columns
    (
     "id",            { data_type => "INT",      default_value => undef,  is_nullable => 0, size => 11, is_auto_increment => 1,     },
     "report_id",     { data_type => "INT",      default_value => undef,  is_nullable => 0, size => 11, is_foreign_key => 1,        },
     "filename",      { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 255,                            },
     "contenttype",   { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 255,                            },
     "filecontent",   { data_type => "LONGBLOB", default_value => "",     is_nullable => 0,                                         },
     "is_compressed", { data_type => "INT",      default_value => 0,      is_nullable => 0,                                         },
     "created_at",    { data_type => "DATETIME", default_value => undef,  is_nullable => 0, set_on_create => 1,                     },
     "updated_at",    { data_type => "DATETIME", default_value => undef,  is_nullable => 0, set_on_create => 1, set_on_update => 1, },
    );

__PACKAGE__->set_primary_key("id");
__PACKAGE__->filter_column('filecontent', {
                                           filter_from_storage => sub { my ($row, $element) = @_;
                                                                        my $uncompressed;
                                                                        if ($row->is_compressed) {
                                                                                eval { $uncompressed = memBunzip( $element ) };
                                                                                return $uncompressed if !$@ && $uncompressed;
                                                                        }
                                                                        return $element;
                                                                      },
                                           filter_to_storage =>   sub { my ($row, $element) = @_;
                                                                        if ($element) {
                                                                                my $compressed;
                                                                                eval {
                                                                                        $compressed = memBzip( $element );
                                                                                };
                                                                                if (!$@ and $compressed) {
                                                                                        $row->is_compressed( 1 );
                                                                                        return $compressed;
                                                                                } else {
                                                                                        $row->is_compressed( 0 );
                                                                                        return $element;
                                                                                }
                                                                        } else {
                                                                                $row->is_compressed( 0 );
                                                                                return $element;
                                                                        }
                                                                      },
                                           }
                           );
__PACKAGE__->belongs_to   ( report => 'Tapper::Schema::TestrunDB::Result::Report', { 'foreign.id' => 'self.report_id' });

1;