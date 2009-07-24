use Test::Base;
use Im::Test;
use Im::Models;

plan 'no_plan';

use File::Temp qw/tempdir/;

my $dir = tempdir( CLEANUP => 1 );
my $socket = "$dir/jsonrpc.socket";

# dummy jsonrpc server
my $child = fork;
if ($child == 0) {
    require AnyEvent::JSONRPC::Lite::Server;

    my $server = AnyEvent::JSONRPC::Lite::Server->new(
        address => 'unix/',
        port    => $socket,
    );
    $server->reg_cb(
        send_message => sub {
            my ($r) = @_;
            $r->result('ok');
        },
    );
    AnyEvent->condvar->recv;
    exit;
}
elsif ($child) {
    models('conf')->{jsonrpc} = {
        address => 'unix/',
        port    => $socket,
    };

    END { kill 9, $child if $child }
}
else {
    die "Fork failed: $!";
}


my $api = models('API::Post');
{
    my $res = $api->post;
    ok !$res, 'error ok';
    is $api->errstr, 'username is empty', 'error message ok';
}

{
    my $res = $api->post(
        username => 'user',
    );
    ok !$res, 'error ok';
    is $api->errstr, 'message is empty', 'error message ok';
}

{
    my $res = $api->post(
        username => 'user',
        message  => 'Hello world!',
    );
    ok !$res, 'error ok';
    is $api->errstr, 'Invalid account "user", please activate account before using this API', 'error message ok';
}

# user;
my $user = models('API::Signup')->signup(
    username => 'user',
    password => 'password',
);
$user->im->update({
    service  => 'jabber',
    username => 'typester@gmail.com',
    valid => 1,
});

{
    my $res = $api->post(
        username => 'user',
        message  => 'Hello world!',
    );
    is $res, 'ok', 'send success';
}

