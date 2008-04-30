package WWW::Favicon;
use strict;
use warnings;
use base qw/Class::Accessor::Fast Exporter/;

use Carp;
use LWP::UserAgent;
use HTML::TreeBuilder;
use HTML::ResolveLink;

our $VERSION = '0.01';
our @EXPORT_OK = qw/detect_favicon_url/;

__PACKAGE__->mk_accessors(qw/ua/);

sub new {
    my $self = shift->SUPER::new(@_);

    $self->{ua} = do {
        my $ua = LWP::UserAgent->new;
        $ua->timeout(10);
        $ua->env_proxy;
        $ua;
    };

    $self;
}

sub detect_favicon_url($) {
    __PACKAGE__->detect(shift);
}

sub detect {
    my ($self, $url) = @_;
    $self = $self->new unless ref $self;

    my $res = $self->ua->get($url);
    croak 'request failed: ' . $res->status_line unless $res->is_success;

    my $resolver = HTML::ResolveLink->new( base => $res->base );
    my $html = $resolver->resolve( $res->content );

    my $tree = HTML::TreeBuilder->new;
    $tree->parse($html);
    $tree->eof;

    my ($icon_url) = grep {$_} map { $_->attr('href') } $tree->look_down(
        _tag => 'link',
        rel  => qr/^(shortcut )?icon$/i,
    );

    unless ($icon_url) {
        $icon_url = $res->base->clone;
        $icon_url->path('/favicon.ico');
    }

    $tree->delete;

    "$icon_url";
}

=head1 NAME

WWW::Favicon - perl module to detect favicon url

=head1 SYNOPSIS

  use WWW::Favicon;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for this module was created by ExtUtils::ModuleMaker.
It looks like the author of the extension was negligent enough
to leave the stub unedited.

Blah blah blah.

=head1 METHODS

=cut

=head1 AUTHOR

Daisuke Murase <typester@cpan.org>

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

1;
