#! /usr/bin/env perl

use lib 'lib';

# Or as a class method, as long as you get it done *before* defining a
#  connection on this schema class or any derived object:

use Artemis::Schema::Tests;
Artemis::Schema::Tests->connection('dbi:mysql:dbname=testsystem;host=alzey', 'root', 'xyzxyzaa');
Artemis::Schema::Tests->dump_to_dir('/tmp/');

