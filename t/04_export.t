use strict;
use warnings;
use Test::More tests => 1;
use WWW::Favicon qw(detect_favicon_url);

ok defined(\&detect_favicon_url), "function exported OK";

