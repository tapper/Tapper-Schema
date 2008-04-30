use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
                                 module_name         => 'Artemis::Schema',
                                 license             => 'restrictive',
                                 dist_author         => 'Steffen Schwigon <steffen.schwigon@amd.com>',
                                 dist_version_from   => 'lib/Artemis/Schema.pm',
                                 requires => {
                                              'Test::More'                  => 0,
                                              'SQL::Translator'             => 0,
                                              'DBD::mysql'                  => 0,
                                              'DBIx::Class'                 => 0,
                                              'DBIx::Class::Schema::Loader' => 0,
                                              'parent'                      => 0,
                                             },
                                 add_to_cleanup      => [ 'Artemis-Schema-*' ],
                                 create_makefile_pl => 'traditional',
                                );

$builder->create_build_script();
