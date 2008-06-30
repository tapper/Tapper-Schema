use strict;
use warnings;

use Module::Build;

my $builder = Module::Build->new
    (
     module_name         => 'Artemis::Schema',
     license             => 'restrictive',
     dist_author         => 'OSRC SysInt Team <osrc-sysint@elbe.amd.com>',
     dist_version_from   => 'lib/Artemis/Schema.pm',
     build_requires => {
                        'Test::More'      => 0,
                        'Artemis::Config' => '2.01',
                        'Artemis::Test'   => 0,
                       },
     requires => {
                  'perl'                           => '5.010',
                  'perl'                           => 0,
                  'DBIx::Class'                    => "0.08099",
                  # 'DBIx::Class::TimeStamp '      => 0, # needed but problems on auto installing
                  'DBIx::Class::Schema::Versioned' => 0,
                 },
     add_to_cleanup      => [ 'Artemis-Schema-*' ],
     create_makefile_pl => 'traditional',
    );

$builder->create_build_script();
