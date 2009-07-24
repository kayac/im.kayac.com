package Im::Controller::API;
use Ark 'Controller';

sub end :Private {
    my ($self, $c) = @_;

    my $json = $c->stash->{json} ||= {};

    $json->{id} = $c->req->param('id') || undef;
    $json->{result} ||= q[] unless defined $json->{result};
    $json->{error}  ||= q[] unless defined $json->{error};

    $c->forward( $c->view('JSON') );
    $c->forward('/end');
}

1;
