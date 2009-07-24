use Test::Base;
use Im::Test '', reuse_connection => 1;
use Im::Models;

plan 'no_plan';

{
    my $c = ctx_get '/';
    is $c->language, 'en', 'default lang is en ok';

    my $res = request GET => '/ja/';
    is $res->code, '302', '302 ok';
    is $res->header('Location'), 'http://localhost/', 'redirect ok';

    $c = ctx_get '/';
    is $c->language, 'ja', 'change to ja ok';

    $res = request GET => '/en/signup/';
    is $res->header('Location'), 'http://localhost/signup/', 'redirect ok';

    $c = ctx_get '/signup';
    is $c->language, 'en', 'rechange to en ok';
}
