package Im::Form::Setting::Activate;
use Ark '+Im::Form';

param code => (
    label => x('Activation code'),
    type  => 'TextField',
    attr  => {
        class    => 'textInput',
        size     => 20,
        readonly => 'readonly',
    },
);

param reset => (
    type   => 'submit',
    widget => 'submit_button',
    label  => x('Delete and start over'),
    value  => 1,
    attr   => {
        class => 'submitButton',
    },
);

1;

