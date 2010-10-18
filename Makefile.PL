use strict;
use warnings;

use inc::Module::Install;

name     'Artemis-Schema';
all_from 'lib/Artemis/Schema.pm';
author   'OSRC SysInt Team <osrc-sysint@elbe.amd.com>';
license  'freebsd';

build_requires 'Test::More'               => 0;
build_requires 'Test::Perl::Critic'       => 0;
build_requires 'Artemis::Config'          => '2.01';
build_requires 'Artemis::Test'            => '2.010011';
build_requires 'Scalar::Util'             => 0;
build_requires 'DateTime::Format::SQLite' => 0;

requires 'perl'                                     => '5.010';
requires 'DBIx::Class'                              => "0.08123";
requires 'common::sense'                            => 0;
requires 'Test::Fixture::DBIC::Schema'              => "0.03";
requires 'DateTime::Format::Builder'                => 0;
requires 'DateTime::Format::Strptime'               => 0;
requires 'DateTime::Format::MySQL'                  => 0;
requires 'DBIx::Class::TimeStamp'                   => '0.12';
requires 'DBIx::Class::Schema::Versioned'           => 0;
requires 'DBIx::Class::InflateColumn::Object::Enum' => 0;
requires 'SQL::Translator'                          => 0;
requires 'Artemis::TAP::Harness'                    => 0;
requires 'TAP::DOM'                                 => '0.07';

WriteAll;
