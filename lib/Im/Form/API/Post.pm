package Im::Form::API::Post;
use Ark 'Form';

param message => (
    type => 'text',
    constraints => [
        'NOT_NULL',
    ],
    
);

1;

