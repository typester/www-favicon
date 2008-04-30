use inc::Module::Install;
name 'WWW-Favicon';
all_from 'lib/WWW/Favicon.pm';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
