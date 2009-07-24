package Im::Controller::Login;
use Ark 'Controller::Form';

sub login :Global :Form('Im::Form::Login') {
    my ($self, $c) = @_;

    if ($c->req->method eq 'POST' and $self->form->submitted_and_valid) {
        my $authenticated = $c->authenticate({
            username => $self->form->valid_param('username'),
            password => $self->form->valid_param('password'),
        });

        if ($authenticated) {
            $c->redirect_and_detach( $c->uri_for( $c->req->param('to') || '/' ) );
        }
        else {
            $self->form->set_error( login => 'failed' );
        }
    }
}

sub logout :Global {
    my ($self, $c) = @_;
    $c->logout;
    $c->redirect( $c->uri_for('/') );
}

1;
