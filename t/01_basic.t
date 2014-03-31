use strict;
use warnings;
use Test::More;
use Test::Requires 'Test::WWW::Mechanize::PSGI';
use MIME::Base64;
use JSON::XS;

{
    package MyApp;
    use parent qw/Amon2/;
}

{
    package MyApp::Web;
    use parent -norequire, qw/MyApp/;
    use parent qw/Amon2::Web/;
    sub dispatch {
        my $c = shift;
        if ($c->request->path_info =~ m!^/info$!) {
            $c->chrome->info('aloha!');
            return $c->create_response(
                200,
                [],
                ['aloha'],
            );
        }
        elsif ($c->request->path_info =~ m!^/warn$!) {
            $c->chrome->warn('mahalo!');
            return $c->create_response(
                200,
                [],
                ['mahalo'],
            );
        }
        return $c->create_response(404, [], []);
    }
    __PACKAGE__->load_plugins('Web::ChromeLogger');
}

my $mech = Test::WWW::Mechanize::PSGI->new(app => MyApp::Web->to_app);

{
    $mech->get_ok('/info');
    $mech->content_contains('aloha');
    my $chrome_log = $mech->res->header('X-ChromeLogger-Data');
    my $json = MIME::Base64::decode_base64($chrome_log);
    my $dat = decode_json($json);
    is $dat->{rows}[0][0][0], 'aloha!';
}

{
    $mech->get_ok('/warn');
    $mech->content_contains('mahalo');
    my $chrome_log = $mech->res->header('X-ChromeLogger-Data');
    my $json = MIME::Base64::decode_base64($chrome_log);
    my $dat = decode_json($json);
    is $dat->{rows}[0][0][0], 'mahalo!';
}

done_testing;
