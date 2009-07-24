package Im::Controller::API::Post;
use Ark 'Controller';
use Im::Models;

sub index :Path :Args(1) {
    my ($self, $c, $username) = @_;

    my $json = $c->stash->{json} ||= {};

    unless ((my $method = $c->req->method) eq 'POST') {
        $c->res->status(405);   # Method Not Allowed
        $json->{error} = qq[Method "$method" does not allowed"];
        return;
    }

    my $api = models('API::Post');
    my $res = $api->post(
        username  => $username || '',
        message   => $c->req->param('message') || undef,
        password  => $c->req->param('password') || undef,
        signature => $c->req->param('signature') || undef,
    );

    unless (defined $res) {
        $json->{error} = $api->errstr;
        return;
    }

    $json->{result} = $res;
}

1;
