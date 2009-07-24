package Im::Controller::Root;
use Ark 'Controller';

has '+namespace' => default => '';

# default 404 handler
sub default :Path :Args {
    my ($self, $c) = @_;

    $c->res->status(404);
    $c->view('MT')->template('errors/404');
}

# 500 handler
sub error_handler :Private {
    my ($self, $c) = @_;

    $c->res->status(500);
    $c->view('MT')->template('errors/500');

    $c->log( error => $c->error->[-1] );

    $c->error([]);
}

sub auto :Private {
    my ($self, $c) = @_;

    my $lang = $c->session->get('language');
    $c->languages($lang) if $lang;
    $c->languages('en')  if $c->language eq 'i-default';

    1;
}

sub index :Path {
    my ($self, $c) = @_;
}

sub end :Private {
    my ($self, $c) = @_;

    $c->res->header('Cache-Control' => 'private');

    # custom error handler
    if (!$c->debug && @{$c->error} ) {
        $c->forward('error_handler');
    }

    # forward default view
    unless ($c->res->body or $c->res->status =~ /^3\d\d/) {
        $c->forward( $c->view('MT') );
    }
}

1;
