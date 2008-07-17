package Artemis::Schema::ReportsDB;

use 5.010;

use strict;
use warnings;

our $VERSION = '2.010012';

use parent 'DBIx::Class::Schema';

our $NULL  = 'NULL';
our $DELIM = ' | ';

__PACKAGE__->load_components(qw/+DBIx::Class::Schema::Versioned/);
__PACKAGE__->upgrade_directory('/var/tmp/');
__PACKAGE__->backup_directory('/var/tmp/');

__PACKAGE__->load_namespaces;


sub backup
{
        #say STDERR "(TODO: Implement backup method.)";
        1;
}

1;

__END__

# ------------------------------------------------------------

# Verzeichnisse erstellen
mkdir -p reportdb/upgrades reportdb/backups

# aktuellen Stand als SQL dumpen, dabei
# *kein* arg4 mit Previous-Versionsnummer angeben
perl -Ilib -MArtemis::Schema::ReportsDB -MArtemis::Model=model -e 'model("ReportsDB")->create_ddl_dir([qw/MySQL SQLite/], undef, "reportdb/upgrades/")'


# Schema und Versionsnummer ändern


# aktuelle Version und Diff erzeugen zur gewünschten vorherigen
# Version erzeugen (diesmal arg4)
perl -I. -MReportDB -e 'ReportDB->connect("DBI:SQLite:foo")->create_ddl_dir([qw/MySQL SQLite/], undef, "reportdb/upgrades/", "2.010001") or die'


# Das connectede Schema von bisheriger Version auf aktuelle Version bringen.
# Dazu die vorher angelegten Diffs in upgrade_directory() verwenden und
# Backups in backup_directory() erzeugen.
perl -I. -MReportDB -e 'my $s = ReportDB->connect("DBI:SQLite:foo"); $s->upgrade or die'
