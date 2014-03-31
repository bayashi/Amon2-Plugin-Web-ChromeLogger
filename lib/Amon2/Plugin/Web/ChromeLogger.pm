package Amon2::Plugin::Web::ChromeLogger;
use strict;
use warnings;
use Web::ChromeLogger;

our $VERSION = '0.01';

sub init {
    my ($class, $c, $conf) = @_;

    $c->add_trigger('BEFORE_DISPATCH' => sub {
        $_[0]->{chrome_logger} = Web::ChromeLogger->new;
    });

    $c->add_trigger('AFTER_DISPATCH' => sub {
        $_[1]->header('X-ChromeLogger-Data' => $_[0]->{chrome_logger}->finalize);
    });

    Amon2::Util::add_method(
        $c => 'chrome',
        sub {
            $_[0]->{chrome_logger};
        },
    );
}

1;

__END__

=head1 NAME

Amon2::Plugin::Web::ChromeLogger - The Chrome Logger Plugin for Amon2


=head1 SYNOPSIS

in your app

    __PACKAGE__->load_plugins('Web::ChromeLogger');

then in a controller

    $c->chrome->info('aloha!');


=head1 DESCRIPTION

Amon2::Plugin::Web::ChromeLogger is the Chrome Plugin for Amon2.

See L<Web::ChromeLogger>, L<http://craig.is/writing/chrome-logger> for detail


=head1 REPOSITORY

Amon2::Plugin::Web::ChromeLogger is hosted on github
<http://github.com/bayashi/Amon2-Plugin-Web-ChromeLogger>

Welcome your patches and issues :D


=head1 AUTHOR

Dai Okabayashi E<lt>bayashi@cpan.orgE<gt>


=head1 SEE ALSO

L<Amon2>, L<Web::ChromeLogger>


=head1 LICENSE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut
