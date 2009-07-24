package Im::Controller::Lang;
use Ark 'Controller';

sub en :Global :Args {
    my ($self, $c, @path) = @_;

    $c->session->set( language => 'en' );
    $c->redirect_and_detach( $c->uri_for('/', @path, '') );
}

sub ja :Global :Args {
    my ($self, $c, @path) = @_;

    $c->session->set( language => 'ja' );
    $c->redirect_and_detach( $c->uri_for('/', @path, '') );
}

1;
