use Test::More;
use Im::Test;
use Im::Models;

plan 'no_plan';

isa_ok my $api = models('API::Signup'), 'Im::API::Signup';

{
    # success test
    my $callback_called;
    my $user = $api->signup(
        username => 'user1',
        password => 'pass1',
        on_success => sub {
            $callback_called++;
        },
    );

    isa_ok $user, 'Im::Schema::Result::User';
    is $user->username, 'user1', 'username ok';
    is length $user->password, 40, 'password length ok';
    is $user->password, models('::Utils')->encode_password('pass1'), 'password ok';

    my $db_user = models('Schema::User')->single({ username => 'user1' });
    isa_ok $user, 'Im::Schema::Result::User';
    is $user->username, $db_user->username, 'username is same';
    is $user->password, $db_user->password, 'password is save';

    isa_ok $db_user->im, 'Im::Schema::Result::ImAccount', 'create related ok';

    ok $callback_called, 'on_success callback called ok';
}

{
    # fail test
    my $callback_called;
    my $user = $api->signup(
        username => 'user1',
        password => 'pass1',
        on_success => sub {
            $callback_called++;
        },
    );

    ok !$user, 'user does not created ok';
    like $api->errstr, qr/column username is not unique/, 'DB error ok';
    ok !$callback_called, 'on_success does not call ok';
}
