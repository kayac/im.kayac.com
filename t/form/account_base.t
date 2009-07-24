use Test::Base;

plan 'no_plan';

use CGI::Simple;
use Im::Form::Signup;

{
    my $form = Im::Form::AccountBase->new(
        CGI::Simple->new({
            username => '',     # required for submitted flag
        }),
    );

    ok $form->has_error, 'has_error ok';
    is $form->error_message_plain('username'), 'please input Username', 'username error ok';
    is $form->error_message_plain('password'), 'please input Password', 'password error ok';
}

{
    my $form = Im::Form::Signup->new(
        CGI::Simple->new({
            username => 'あああ',
            password => 'ああああ',
        }),
    );

    ok $form->has_error, 'has_error ok';
    is $form->error_message_plain('username'), 'please input Username as ascii characters without space', 'username error ok';
    is $form->error_message_plain('password'), 'please input Password as ascii characters without space', 'password error ok';
}


{
    my $form = Im::Form::Signup->new(
        CGI::Simple->new({
            password => 'hog',
        }),
    );

    ok $form->has_error, 'has_error ok';
    is $form->error_message_plain('password'), 'please input between 6 and 30 characters', 'password error ok';

$form = Im::Form::Signup->new(
        CGI::Simple->new({
            password => '1234567890123456789012345678901',
        }),
    );

    ok $form->has_error, 'has_error ok';
    is $form->error_message_plain('password'), 'please input between 6 and 30 characters', 'password error ok';
}

