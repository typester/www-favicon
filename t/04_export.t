use strict;
use warnings;
no warnings qw(once);
use Test::More tests => 1;
use WWW::Favicon qw(detect_favicon_url);

ok defined(*detect_favicon_url{CODE}), "function exported OK";
