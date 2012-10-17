
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.3601",
    "Test::More" => 0
  },
  "configure_requires" => {
    "ExtUtils::MakeMaker" => "6.30",
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "SimpleAuth Client",
  "dist_author" => [
    "Graham Ollis <gollis\@sesda2.com>"
  ],
  "dist_name" => "SimpleAuth-Client",
  "dist_version" => "0.09",
  "license" => "restrictive",
  "module_name" => "SimpleAuth::Client",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Clustericious::Client" => "0.08",
    "Clustericious::Client::Command" => 0,
    "File::Basename" => 0,
    "File::Spec" => 0,
    "Log::Log4perl" => 0,
    "Log::Log4perl::CommandLine" => 0,
    "perl" => "v5.10.0",
    "strict" => 0,
    "warnings" => 0
  },
  "script_files" => [
    "bin/simpleauthclient"
  ]
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
