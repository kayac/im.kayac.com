use inc::Module::Install;
name 'Im';
all_from 'lib/Im.pm';

requires 'Ark';

tests 't/*.t, t/*/*.t';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
