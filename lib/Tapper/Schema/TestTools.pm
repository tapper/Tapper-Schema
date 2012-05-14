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

sub setup_db
{
        # explicitely prefix into {test} subhash of the config file,
        # to avoid painful mistakes with deploy

        my ($db, $cfgbase) = @_;

        my $cfg = $cfgbase->{$db};
        my $dsn = $cfg->{dsn};
        my ($tmpfname) = $dsn =~ m,dbi:SQLite:dbname=([\w./]+),i;
        unlink $tmpfname;
        my $schema = $db eq "ReportsDB" ? Tapper::Schema::ReportsDB->connect($dsn, $cfg->{username}, $cfg->{password}, { ignore_version => 1 })
                                        : Tapper::Schema::TestrunDB->connect($dsn, $cfg->{username}, $cfg->{password}, { ignore_version => 1 });
        $schema->deploy;
        $schema->upgrade if $schema->schema_version > $schema->get_db_version;
        return $schema;
}

sub setup_testrundb {
        $testrundb_schema = setup_db("TestrunDB", Tapper::Config->subconfig->{test}{database});
}

sub setup_reportsdb {
        $reportsdb_schema = setup_db("ReportsDB", Tapper::Config->subconfig->{test}{database});
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
