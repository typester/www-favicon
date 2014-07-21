use strict;
use warnings;
use Test::More;
use Test::MockObject::Extends;
use LWP::UserAgent;
use WWW::Favicon;
use HTTP::Response;

my $mock = Test::MockObject::Extends->new(LWP::UserAgent->new);
my @get_log = ();
$mock->mock(get => sub {
    push @get_log, \@_;
    return HTTP::Response->new(404);
});

my $f = WWW::Favicon->new(ua => $mock);

@get_log = ();
eval { $f->detect('http://example.com/') };
cmp_ok scalar(@get_log), '>', 0, 'at least 1 get() request';
is $get_log[0][0], 'http://example.com', 'get() request captured OK';

is $f->ua, $mock, 'ua() method should return the useragent';

is $f->ua(10), 10, 'ua() setter should return the given value';
is $f->ua, 10, 'ua() setter should set the useragent';


done_testing;
