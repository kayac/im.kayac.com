package Im::Controller::RequireSignin;
use Ark 'Controller';

sub auto :Private {
    my ($self, $c) = @_;

    unless ($c->user && $c->user->authenticated) {
        $c->redirect( $c->uri_for('/login', { to => $c->req->uri->path_query }) );
        return;
    }

    1;
}

1;

