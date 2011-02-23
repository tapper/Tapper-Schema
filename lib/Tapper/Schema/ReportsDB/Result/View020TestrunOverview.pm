package Tapper::Schema::ReportsDB::Result::View020TestrunOverview;
# the number is to sort classes on deploy

use 5.010;
use strict;
use warnings;

use parent 'DBIx::Class::Core';

__PACKAGE__->table_class('DBIx::Class::ResultSource::View');

__PACKAGE__->table('view_testrun_overview');

# virtual is needed when the query should accept parameters
__PACKAGE__->result_source_instance->is_virtual(0);
__PACKAGE__->result_source_instance->view_definition
    (
     "select vtor.*, ".
     "       r.machine_name, ".
     "       r.created_at, ".
     "       r.suite_id, ".
     "       s.name as suite_name ".
     "from view_testrun_overview_reports vtor, ".
     "     report r, ".
     "     suite s ".
     "where vtor.primary_report_id=r.id and ".
     "      r.suite_id=s.id"
    );

__PACKAGE__->add_columns
    (
     # view_testrun_overview_reports
     'rgt_testrun_id'     => { data_type => 'INT',      size => 11  },
     'rgts_success_ratio' => { data_type => 'varchar',  size => 20  },
     'primary_report_id'  => { data_type => 'INT',      size => 11  },
     # report
     'machine_name'       => { data_type => 'varchar',  size => 50  },
     'created_at'         => { data_type => 'DATETIME'              },
     'suite_id'           => { data_type => 'varchar',  size => 11  },
     # suite
     'suite_name'         => { data_type => 'varchar',  size => 255 },
    );

1;
