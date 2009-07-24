use Test::Base;
use Im::Test undef, reuse_connection => 1;

use HTTP::Request::Common;

plan 'no_plan';

{
    # success
    my $res = request POST '/signup', [
        username => 'user1',
        password => 'user1_password',
    ];

    is $res->code, 302, 'status 302 ok';

    my $redirect_to = URI->new($res->header('Location'));
    is $redirect_to->path, '/signup/complete', 'redirect path ok';

    $res = request GET => $redirect_to->path;
    like $res->content, qr/Your account was successfully created./, 'complete screen ok';
}

{
    # redirect if user already logged in
    my $res = request GET => '/signup';

    is $res->code, 302, '302 ok';

    my $redirect_to = URI->new($res->header('Location'));
    is $redirect_to->path, '/', 'redirect path ok';
}

reset_app; # kill session

{
    my $res = request POST '/signup', [
        username => 'user1',    # already exists
        password => 'user1_password',
    ];

    is $res->code, 200, '200 ok';
    like $res->content, qr/already taken/, 'error message ok';

    $res = request GET => '/signup/complete';

    is $res->code, 302, '302 redirect ok';
    is $res->header('Location'), 'http://localhost/signup/', 'non-user redirect to singup form';
}

