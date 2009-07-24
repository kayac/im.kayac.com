use Test::Base;

plan 'no_plan';

use CGI::Simple;
use Im::Test;
use Im::Form::Signup;

use Im::Models;

my $res = models('API::Signup')->signup(
    username => 'foobar',
    password => 'foobar',
);

ok $res, 'create dummy user ok';

{
    my $form = Im::Form::Signup->new(
        CGI::Simple->new({
            username => 'foobar',
            password => 'foobar',
        }),
    );

    ok $form->has_error, 'has_error ok';
    is $form->error_message_plain('username'), 'this username already taken', 'already taken error ok';
}
