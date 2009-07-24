use Test::Base;
use Im::Test '', reuse_connection => 1;
use Im::Models;

use HTTP::Request::Common;

plan 'no_plan';

# redirect to login
{
    my $res = request GET => '/setting';
    is $res->code, '302', '302 status ok';
    is $res->header('Location'), 'http://localhost/login?to=%2Fsetting', 'redirect ok';
}

# login
{
    my $user = models('API::Signup')->signup(
        username => 'user',
        password => 'password',
    );
    isa_ok $user, 'Im::Schema::Result::User', 'create user ok';

    my $res = request POST '/login', [
        username => 'user',
        password => 'password',
    ];

    is $res->code, '302', '302 status ok';
    is $res->header('Location'), 'http://localhost/', 'redirect ok';
}

# setting/setting
{
    my $res = request GET => '/setting';
    is $res->code, '200', '200 ok';

    $res = request POST '/setting', [
        im => '',
    ];
    is $res->code, '200', '200 ok';
    like $res->content, qr/Please select IM type/, 'invalid form ok';

    $res = request POST '/setting', [
        im      => 'jabber',
        account => 'typester@gmail.com',
        auth    => 'no',
    ];
    is $res->code, '302', '302 ok';
}

# setting/activate
{
    my $res = request GET => '/setting';
    is $res->code, '200', '200 ok';

    my $user = models('Schema::User')->single({ username => 'user' });
    my $code = $user->im->validation_code;

    like $res->content, qr/$code/, 'validation code display ok';

    # activate
    ok $user->im->activate($code), 'activation success';
}

# setting/setting fillform
{
    my $res = request GET '/setting';
    like $res->content, qr/typester\@gmail\.com/, 'account fills ok';
}

# setting/reset
{
    my $user = models('Schema::User')->single({ username => 'user' });
    $user->im->update({ valid => 0 });

    my $res = request GET => '/setting';
    like $res->content, qr/reset/, 'reset button ok';

    $res = request POST '/setting', [ reset => 1 ];
    is $res->code, '302', '302 ok';
    is $res->header('Location'), 'http://localhost/setting/', 'redirect ok';

    $res = request GET '/setting';
    unlike $res->content, qr/reset/, 'show normal form ok';
}
