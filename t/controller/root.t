use Test::Base;
use Ark::Test 'Im';

plan 'no_plan';

# /default
{
    my $r = request GET => '/aoeirgnr';
    ok(!$r->is_success, 'request is not success ok');
    is($r->code, 404, '404 status ok');
    like($r->content, qr{<title>404 - Not Found</title>}, '404 template ok');
}

# /error_handler
{
    # virtual error
    no warnings 'once', 'redefine';
    local *Im::Controller::Root::index = sub {
        die;
    };

    my $r = request GET => '/';
    ok(!$r->is_success, 'resuest is not success ok');
    is($r->code, 500, '500 status ok');
    like($r->content, qr{<title>500 - Internal Server Error</title>}, '500 template ok')
}

# /auto (language detection)
{
    # without lang
    my $req = HTTP::Request->new( GET => '/' );
    my $c = ctx_request($req);

    is( $c->language, 'en', 'default is en ok');

    # ja
    $req->header( 'Accept-Language' => 'ja' );
    $c = ctx_request($req);
    is $c->language, 'ja', 'ja ok';

    $req->header( 'Accept-Language' => 'en, ja' );
    $c = ctx_request($req);
    is $c->language, 'en', 'en ok';
}

# /index
{
    my $r = request GET => '/';
    ok($r->is_success, 'resuest success ok');
    like($r->content, qr{<h2>Simple instant message \(IM\) posting API</h2>}, 'content ok');
}
