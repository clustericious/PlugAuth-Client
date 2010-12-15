use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'SimpleAuth::Client',
    license             => 'perl',
    dist_author         => q{Brian Duggan <brian.duggan@nasa.gov>},
    dist_version_from   => 'lib/SimpleAuth/Client.pm',
    requires => {
        'Clustericious::Client' => '0.08',
    },
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'SimpleAuth-Client-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
