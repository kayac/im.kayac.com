use Test::More;
use HTTP::Request::Common;

{
    package Im::Controller::ThisTest;
    use Ark '+Im::Controller::RequireSignin';

    sub index :Path {
        my ($self, $c) = @_;
        $c->res->body('secret content');
    }
}

use Im::Models;
use Im::Test '', components => 'Controller::ThisTest',
    reuse_connection => 1;

{
    my $res = request GET => '/thistest';
    is $res->code, 302, 'redirect ok';

    my $expected = URI->new('http://localhost/login');
    $expected->query_form( to => '/thistest' );

    is $res->header('Location'), "$expected", 'redirect url ok';
}

my %info = (
    username => 'user1',
    password => 'user1_pass',
);
my $user = models('API::Signup')->signup(%info);
isa_ok $user, 'Im::Schema::Result::User', 'create user ok';

{
    my $res = request POST '/login', [%info];
    my $c = ctx_get '/';

    ok $c->user, 'login successful';

    is get('/thistest'), 'secret content', 'content ok';
}

done_testing;
