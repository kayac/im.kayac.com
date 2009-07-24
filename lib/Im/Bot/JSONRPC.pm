package Im::Bot::JSONRPC;
use Any::Moose;

use Im::Models;
use AnyEvent::JSONRPC::Lite::Server;

has address => (
    is      => 'ro',
    isa     => 'Maybe[Str]',
    default => 'unix/',
);

has port => (
    is      => 'ro',
    isa     => 'Int | Str',
    default => sub {
        models('home')->subdir('tmp')->file('jsonrpc.socket')->stringify,
    },
);

has jsonrpc => (
    is      => 'rw',
    isa     => 'AnyEvent::JSONRPC::Lite::Server',
    lazy    => 1,
    default => sub {
        my ($self) = @_;

        AnyEvent::JSONRPC::Lite::Server->new(
            address => $self->address,
            port    => $self->port,
        );
    },
    handles => [qw/reg_cb/],
);

__PACKAGE__->meta->make_immutable;

