package Im::Models;
use Ark::Models -Base;

register schema => sub {
    my $self = shift;
    $self->ensure_class_loaded('Im::Schema');

    my $conf = $self->get('conf');
    Im::Schema->connect( @{ $conf->{database} } );
};

# shortcut for resultsets
for my $table (qw/User ImAccount/) {
    register "Schema::$table" => sub {
        shift->get('schema')->resultset($table);
    };
}

register cache => sub {
    my $self = shift;
    my $conf = $self->get('conf');

    $self->adaptor($conf->{cache});
};

register sha1 => sub {
    shift->ensure_class_loaded('Digest::SHA1');
    Digest::SHA1->new;
};

register uuid => sub {
    shift->ensure_class_loaded('Data::UUID');
    Data::UUID->new;
};

register json => sub {
    shift->ensure_class_loaded('JSON::XS');
    JSON::XS->new->utf8;
};

register jsonrpc => sub {
    my $self = shift;
    my $conf = $self->get('conf')->{jsonrpc};
    my $home = $self->get('home');

    $self->ensure_class_loaded('JSONRPC::Transport::TCP');
    JSONRPC::Transport::TCP->new(
        host => $conf->{address} || 'unix/',
        port => $conf->{port}    || $home->subdir('tmp')->file('jsonrpc.socket'),
    );
};

register_namespaces API => 'Im::API';

1;
