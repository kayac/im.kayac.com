package Im::Form::Signup;
use Ark '+Im::Form::AccountBase';
use Im::Models;

param '+username' => (
    custom_validation => sub {
        my ($self, $form, $field) = @_;
        return if $form->is_error( $field->name );

        if (models('Schema::User')->single({ username => $form->param($field->name) })) {
            $form->set_error( $field->name, 'already_taken' );
        }
    },
);

sub messages {
    return {
        %{ shift->SUPER::messages },
        'username.already_taken' => x('this username already taken'),
    };
}

1;
