package Tapper::Schema::TestTools;

# inspired by Test::Fixture::DBIC::Schema

use strict;
use warnings;

BEGIN {
        use Class::C3;
        use MRO::Compat;
        $DBD::SQLite::sqlite_version; # fix "used only once" warning
}

use Tapper::Schema::TestrunDB;
use Tapper::Schema::ReportsDB;

use Tapper::Config;

my $testrundb_schema;
my $reportsdb_schema;

sub setup_testrundb {

        # explicitely prefix into {test} subhash of the config file,
        # to avoid painful mistakes with deploy

        my $dsn = Tapper::Config->subconfig->{test}{database}{TestrunDB}{dsn};

        my ($tmpfname) = $dsn =~ m,dbi:SQLite:dbname=([\w./]+),i;
        unlink $tmpfname;

        $testrundb_schema = Tapper::Schema::TestrunDB->connect($dsn,
                                                                Tapper::Config->subconfig->{test}{database}{TestrunDB}{username},
                                                                Tapper::Config->subconfig->{test}{database}{TestrunDB}{password},
                                                                { ignore_version => 1 }
                                                               );
        $testrundb_schema->deploy;
        $testrundb_schema->upgrade;
}

sub setup_reportsdb {

        # explicitely prefix into {test} subhash of the config file,
        # to avoid painful mistakes with deploy

        my $dsn = Tapper::Config->subconfig->{test}{database}{ReportsDB}{dsn};

        my ($tmpfname) = $dsn =~ m,dbi:SQLite:dbname=([\w./]+),i;
        unlink $tmpfname;

        $reportsdb_schema = Tapper::Schema::ReportsDB->connect($dsn,
                                                                Tapper::Config->subconfig->{test}{database}{ReportsDB}{username},
                                                                Tapper::Config->subconfig->{test}{database}{ReportsDB}{password},
                                                                { ignore_version => 1 }
                                                               );
        $reportsdb_schema->deploy;
        $reportsdb_schema->upgrade;
}


sub import {
        my $pkg = caller(0);
        no strict 'refs';       ## no critic.
        *{"$pkg\::testrundb_schema"}  = sub () { $testrundb_schema };
        *{"$pkg\::reportsdb_schema"}  = sub () { $reportsdb_schema };
}

setup_testrundb;
setup_reportsdb;

1;
