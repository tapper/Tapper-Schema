use strict;
use warnings;

use inc::Module::Install;

name     'Tapper-Schema';
all_from 'lib/Tapper/Schema.pm';
author   'AMD OSRC Tapper Team <tapper@amd64.org>';
license  'freebsd';

build_requires 'Test::More'               => 0;
build_requires 'Test::Perl::Critic'       => 0;
build_requires 'Tapper::Config'           => "3.000002";
build_requires 'Tapper::Test'             => "3.000002";
build_requires 'Scalar::Util'             => 0;
build_requires 'DateTime::Format::SQLite' => 0;

author_requires 'Module::Install::WriteAll';

requires 'perl'                                     => '5.010';
requires 'DBIx::Class'                              => "0.08127";
requires 'common::sense'                            => 0;
requires 'Test::Fixture::DBIC::Schema'              => "0.03";
requires 'DateTime::Format::Builder'                => 0;
requires 'DateTime::Format::Strptime'               => 0;
requires 'DateTime::Format::MySQL'                  => 0;
requires 'DBIx::Class::TimeStamp'                   => '0.12';
requires 'DBIx::Class::Schema::Versioned'           => 0;
requires 'DBIx::Class::InflateColumn::Object::Enum' => 0;
requires 'SQL::Translator'                          => 0;
requires 'Tapper::TAP::Harness'                     => '2.010040';
requires 'TAP::DOM'                                 => '0.10';
#requires 'YAML'                                     => "0.72"; # we try to focus on one YAML to rule them all.
requires 'YAML::Syck'                               => "1.17";

WriteAll;
