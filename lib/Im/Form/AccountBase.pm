package Im::Form::AccountBase;
use Ark '+Im::Form';

param username => (
    type => 'TextField',
    label => x('Username'),
    attr => {
        class => 'textInput',
        size  => 20,
    },
    constraints => [
        'NOT_NULL',
        'ASCII',
    ],
);

param password => (
    type  => 'PasswordField',
    label => x('Password'),
    attr => {
        class => 'textInput',
        size  => 20,
    },
    constraints => [
        'NOT_NULL',
        'ASCII',
        ['LENGTH', '6', '30'],
    ],
    messages => {
        length => x('please input between 6 and 30 characters'),
    },
);


