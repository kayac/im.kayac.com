package Im::Form::Setting;
use Ark '+Im::Form';

param im => (
    id      => 'im',
    type    => 'ChoiceField',
    label   => x('IM'),
    choices => [
        '' => '',
        gtalk  => 'Google Talk',
        jabber => 'Jabber',
    ],
    attr => {
        class => 'selectInput',
    },
    constraints => ['NOT_NULL'],
    messages => {
        not_null => 'Please select IM type',
    },
);

param account => (
    id    => 'account',
    type  => 'TextField',
    label => x('Account'),
    attr => {
        size  => 20,
        class => 'textInput',
    },
    constraints => ['NOT_NULL'],
);

param auth => (
    type    => 'ChoiceField',
    label   => x('Use authentication'),
    widget  => 'radio',         # FIXME
    choices => [
        no        => x('No. Anyone can post message to you'),
        password  => x('Use password authentication'),
        secretkey => x('Use secret key authentication'),
    ],
);

param password => (
    type  => 'TextField',
    label => x('Password'),
    attr  => {
        class => 'textInput',
        size  => 20,
    },
    constraints => ['NOT_NULL', 'ASCII'],
    custom_validation => sub {
        my ($self, $form, $field) = @_;
        unless (($form->param('auth') || '') eq 'password') {
            $self->ignore_error($form, $field->name);
        }
    },
);

param secretkey => (
    type  => 'Textinput',
    label => x('Secret key'),
    attr  => {
        class => 'textInput',
        size  => 20,
    },
    constraints => ['NOT_NULL', 'ASCII'],
    custom_validation => sub {
        my ($self, $form, $field) = @_;
        unless (($form->param('auth') || '') eq 'secretkey') {
            $self->ignore_error($form, $field->name);
        }
    },
);

1;

