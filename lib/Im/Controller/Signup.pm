package Im::Controller::Signup;
use Ark 'Controller::Form';
use Im::Models;

sub index :Path :Form('Im::Form::Signup') {
    my ($self, $c) = @_;

    $c->redirect_and_detach( $c->uri_for('/') ) if $c->user;

    if ($c->req->method eq 'POST' and $self->form->submitted_and_valid) {
        my %signup_params = (
            username => $self->form->valid_param('username'),
            password => $self->form->valid_param('password'),
        );

        my $api = models('API::Signup');
        my $res = $api->signup(
            %signup_params,
            on_success => sub {
                $c->authenticate(\%signup_params);
            },
        ) or die $api->errstr;

        $c->redirect_and_detach( $c->uri_for('/signup/complete') );
    }
}

sub complete :Local {
    my ($self, $c) = @_;

    unless ($c->user) {
        $c->redirect_and_detach( $c->uri_for('/signup/') );
    }
}

1;
