
use strict;
use warnings;
use Test::More tests => 7;
use Tapper::Config;

use_ok('Tapper::Schema');

use Test::Fixture::DBIC::Schema;
use Tapper::Schema::TestTools;

# --------------------------------------------------------------------------------
construct_fixture( schema  => testrundb_schema,  fixture => 't/fixtures/testrundb/pool_testrun.yml' );
# --------------------------------------------------------------------------------

sub model
{
        my ($schema_basename) = @_;

        $schema_basename ||= 'TestrunDB';

        my $schema_class = "Tapper::Schema::$schema_basename";

        # lazy load class
        eval "use $schema_class";
        if ($@) {
                print STDERR $@;
                return undef;
        }
        return $schema_class->connect(Tapper::Config->subconfig->{database}{$schema_basename}{dsn},
                                      Tapper::Config->subconfig->{database}{$schema_basename}{username},
                                      Tapper::Config->subconfig->{database}{$schema_basename}{password});
}

my $job = model->resultset('TestrunScheduling')->first;
isa_ok($job, 'Tapper::Schema::TestrunDB::Result::TestrunScheduling');

my $host = model->resultset('Host')->find({name => 'pool_iring'});
$job->host_id($host->id);
ok($job->host->is_pool, 'Host is pool host');

$job->mark_as_running;
is($job->host->pool_count, 1, 'One less host in pool');
ok($job->host->free, 'Nonempty pool still free');

$job->mark_as_running;
is($job->host->pool_count, 0, 'One less host in pool');
is($job->host->free, 0, 'Empty pool no longer free');

