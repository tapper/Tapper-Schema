
use Artemis::Schema::Tests;
use SQL::Translator;

my $schema = Artemis::Schema::Tests->connect([ "dbi:mysql:dbname=testsystem;host=alzey", "root", "xyzxyzaa" ])

my $translator =  SQL::Translator->new
    (
     debug                => $debug          ||  0,
     trace                => $trace          ||  0,
     no_comments          => $no_comments    ||  0,
     show_warnings        => $show_warnings  ||  0,
     add_drop_table       => $add_drop_table ||  0,
     validate             => $validate       ||  0,
     parser_args          => {
                              'DBIx::Schema' => $schema,
                             },
     producer_args   => {
                         'prefix'            => 'Artemis::Schema::Tests',
                        },
    );

$translator->parser('SQL::Translator::Parser::DBIx::Class');
$translator->producer('SQL::Translator::Producer::DBIx::Class::File');

my $output = $translator->translate(@args) or die
    "Error: " . $translator->error;

print $output;
