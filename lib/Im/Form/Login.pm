package Im::Form::Login;
use Ark '+Im::Form::AccountBase';

sub messages {
    return {
        %{ $_[0]->SUPER::messages },
        'login.failed' => x('Failed to login. Username or password is wrong.'),
    };
}

1;
