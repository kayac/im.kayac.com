use Test::More;
use Im::Test '', reuse_connection => 1;

use Im::Models;
use HTTP::Request::Common;

{
    # form error
    my $res = request POST '/login', [
        username => '',
        password => 'aaa',
    ];

    is $res->code, 200, '200 ok';
    like $res->content, qr/please input Username/, 'username error ok';
    like $res->content, qr/please input between 6 and 30 characters/, 'password error ok';
}


{
    # unknown user
    my $res = request POST '/login', [
        username => 'user1',
        password => 'user1_password',
    ];

    is $res->code, 200, '200 ok';
    like $res->content, qr/Failed to login\./, 'login error ok';
}

# create user
my $user = models('API::Signup')->signup(
    username => 'user1',
    password => 'user1_password',
);

isa_ok $user, 'Im::Schema::Result::User', 'create user ok';

{
    my $res = request POST '/login', [
        username => 'user1',
        password => 'user1_password',
    ];

    is $res->code, 302, '302 code ok';
    is $res->header('Location'), 'http://localhost/', 'redirect after login ok';
}

{
    my ($res, $c) = ctx_request GET => '/';
    isa_ok $c->user->obj, 'Im::Schema::Result::User', 'successfully logged in ok';
    is $c->user->obj->username, 'user1', 'username ok';
}

{
    my $res = request GET => '/logout';
    is $res->code, '302', 'logout redirect ok';
    is $res->header('Location'), 'http://localhost/', 'redirect to top ok';

    my $c = ctx_get '/';
    ok !$c->user, 'logout ok';
}

{
    # login?to=/path/to
    my $res = request my $req = POST '/login', [
        username => 'user1',
        password => 'user1_password',
        to => '/foo/bar',
    ];

    is $res->code, '302', 'redirect after login ok';
    is $res->header('Location'), 'http://localhost/foo/bar', 'redirect to ok';

}


done_testing;

