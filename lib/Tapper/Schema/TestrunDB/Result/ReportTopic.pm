package Tapper::Schema::TestrunDB::Result::ReportTopic;

# ABSTRACT: Tapper - containg topic information for reports

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("reporttopic");
__PACKAGE__->add_columns
    (
     "id",                        { data_type => "INT",      default_value => undef,  is_nullable => 0, size => 11, is_auto_increment => 1, },
     "report_id",                 { data_type => "INT",      default_value => undef,  is_nullable => 0, size => 11, is_foreign_key => 1,    },
     "name",                      { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 255,                        },
     "details",                   { data_type => "TEXT",     default_value => "",     is_nullable => 0,                                     },
    );

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to   ( report => 'Tapper::Schema::TestrunDB::Result::Report', { 'foreign.id' => 'self.report_id' });


1;