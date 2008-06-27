package Artemis::Schema::ReportsDB;

use strict;
use warnings;

our $VERSION = '1.001';

use parent 'DBIx::Class::Schema';

our $NULL  = 'NULL';
our $DELIM = ' | ';

__PACKAGE__->load_components(qw/+DBIx::Class::Schema::Versioned/);
__PACKAGE__->load_namespaces;

__PACKAGE__->upgrade_directory('reportdb/upgrades/');
__PACKAGE__->backup_directory('reportdb/backups/');

# Tried to deactivate the warnings. With no success.
# sub connect {
#         my $self = shift;
#         no warnings;
#         print STDERR "*** BUH! ***\n";
#         $self->SUPER::connect(@_);
# }

1;

=head1 NAME

Artemis::Schema::ReportsDB - Artemis Database Schema for Reports

=hea1 VERSION

Version 0.01

=head1 SYNOPSIS

 use Artemis::Schema::ReportsDB;

=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>

=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive

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
