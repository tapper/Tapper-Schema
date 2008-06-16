package Artemis::Schema::ReportsDB::Result::Report;

use strict;
use warnings;

use parent 'DBIx::Class';
use parent 'Artemis::Schema::Printable';

__PACKAGE__->load_components(qw(InflateColumn::DateTime TimeStamp Core));
__PACKAGE__->table("report");
__PACKAGE__->add_columns
    (
     "id",                      { data_type => "INT",      default_value => undef,  is_nullable => 0, size => 11, is_auto_increment => 1, },
     "suite_id",                { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 11, is_foreign_key => 1,    },
     "suite_version",           { data_type => "VARCHAR",  default_value => undef,  is_nullable => 1, size => 11,                         },
     #
     "tap",                     { data_type => "TEXT",     default_value => "",     is_nullable => 0, size => 65535,                      },
     "successgrade",            { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 10,                         },
     "reviewed_successgrade",   { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 10,                         },
     #
     #
     "total",                   { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                         },
     "failed",                  { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                         },
     "parse_errors",            { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                         },
     "passed",                  { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                         },
     "skipped",                 { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                         },
     "todo",                    { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                         },
     "todo_passed",             { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                         },
     "wait",                    { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                         },
     "exit",                    { data_type => "INT",      default_value => undef,  is_nullable => 1, size => 10,                         },
     "success_ratio",           { data_type => "VARCHAR",  default_value => undef,  is_nullable => 1, size => 20,                         },

     #
     "starttime_test_program",  { data_type => "DATETIME", default_value => undef,  is_nullable => 1,                                     },
     "endtime_test_program",    { data_type => "DATETIME", default_value => undef,  is_nullable => 1,                                     },
     #
     #
     "machine_name",            { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 50,                         },
     "machine_description",     { data_type => "TEXT",     default_value => "",     is_nullable => 1, size => 65535,                      },
     #
     "created_at",              { data_type => "DATETIME", default_value => undef,  is_nullable => 0, set_on_create => 1,                 },
     "updated_at",              { data_type => "DATETIME", default_value => undef,  is_nullable => 0, set_on_create => 1, set_on_update => 1, },
     "reportername",            { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 100,                        },
     #
     # TODO: these all get into ReportSection
     "osname",                  { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 255,                        },
     "uname",                   { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 255,                        },
     "language_description",    { data_type => "TEXT",     default_value => "",     is_nullable => 1, size => 255,                        },
     "cpuinfo",                 { data_type => "TEXT",     default_value => "",     is_nullable => 1, size => 65535,                      },
     "ram",                     { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 50,                         },
     "lspci",                   { data_type => "TEXT",     default_value => "",     is_nullable => 1, size => 65535,                      },
     "lsusb",                   { data_type => "TEXT",     default_value => "",     is_nullable => 1, size => 65535,                      },
     "flags",                   { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 255,                        },
     "xen_changeset",           { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 255,                        },
     "xen_hvbits",              { data_type => "VARCHAR",  default_value => "",     is_nullable => 1, size => 10,                         },
     "xen_dom0_kernel",         { data_type => "TEXT",     default_value => "",     is_nullable => 1, size => 65535,                      },
     "xen_base_os_description", { data_type => "TEXT",     default_value => "",     is_nullable => 1, size => 65535,                      },
     "xen_guests_description",  { data_type => "TEXT",     default_value => "",     is_nullable => 1, size => 65535,                      },
     "test_was_on_guest",       { data_type => "INT",      default_value => 0,      is_nullable => 1, size => 1,                          },
     "test_was_on_hv",          { data_type => "INT",      default_value => 0,      is_nullable => 1, size => 1,                          },
    );

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to   ( suite    => 'Artemis::Schema::ReportsDB::Result::Suite',         { 'foreign.id'        => 'self.suite_id' });

__PACKAGE__->has_many     ( comments       => 'Artemis::Schema::ReportsDB::Result::ReportComment', { 'foreign.report_id' => 'self.id' });
__PACKAGE__->has_many     ( topics         => 'Artemis::Schema::ReportsDB::Result::ReportTopic',   { 'foreign.report_id' => 'self.id' });
__PACKAGE__->has_many     ( files          => 'Artemis::Schema::ReportsDB::Result::ReportFile',    { 'foreign.report_id' => 'self.id' });
__PACKAGE__->has_many     ( reportsections => 'Artemis::Schema::ReportsDB::Result::ReportSection', { 'foreign.report_id' => 'self.id' });


1;

=head1 NAME

Artemis::Schema::ReportsDB::Report - A ResultSet description


=head1 SYNOPSIS

Abstraction for the database table.

 use Artemis::Schema::ReportsDB;


=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive

