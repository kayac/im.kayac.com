use Test::More;
use Im::Test;

use Im::Form::Login;
use CGI::Simple;

{
    # login failed
    my $form = Im::Form::Login->new(
        CGI::Simple->new({ username => 'hoge', password => 'hogehoge', }),
    );

    ok $form->submitted_and_valid, 'submitted_and_valid ok';

    $form->set_error( login => 'failed' );
    ok $form->has_error, 'has_error ok';

    is $form->error_message_plain('login'),
        'Failed to login. Username or password is wrong.', 'error message ok';
}

done_testing;
