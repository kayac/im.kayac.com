package Im::Bot;
use Any::Moose;

use Im::Models;
use Im::Bot::Jabber;
use Im::Bot::JSONRPC;

use AnyEvent::Gearman::Client;

has jabber => (
    is  => 'rw',
    isa => 'Im::Bot::Jabber',
);

has rpc => (
    is  => 'rw',
    isa => 'Im::Bot::JSONRPC',
);

has gearman => (
    is      => 'rw',
    isa     => 'AnyEvent::Gearman::Client',
    lazy    => 1,
    default => sub {
        my $self = shift;
        my $conf = models('conf')->{gearman};

        AnyEvent::Gearman::Client->new($conf);
    },
);

has _loop_guard => (
    is      => 'rw',
    isa     => 'AnyEvent::CondVar',
    lazy    => 1,
    default => sub { AnyEvent->condvar },
);

no Any::Moose;

sub BUILDARGS {
    my ($self, $args) = @_;

    return {
        jabber => Im::Bot::Jabber->new($args->{jabber} || {}),
        rpc    => Im::Bot::JSONRPC->new($args->{jsonrpc} || {}),
    };
}

sub BUILD {
    my ($self) = @_;

    $self->jabber->on_message(sub { $self->on_jabber_message(@_) });
    $self->jabber->connect;

    $self->rpc->reg_cb(
        send_message => sub {
            my $r = shift;
            my ($to, $message) = @_;

            return $r->error('invalid parameters')
                unless $to && $message;

            $self->jabber->send_message( $to => $message );

            $r->result('ok');
        },
    );
}

sub start {
    my $self = shift;
    $self->_loop_guard->recv;
}

sub stop {
    my $self = shift;
    $self->_loop_guard->send;
}

sub on_jabber_message {
    my ($self, $msg) = @_;

    # activate request
    if (length($msg->body) == 40) {
        (my $from = $msg->from) =~ s!/.*!!;

        my $workload = models('json')->encode({
            code    => $msg->body,
            address => $from,
        });

        $self->gearman->add_task(
            activate    => $workload,
            on_complete => sub {
                $self->jabber->send_message( $msg->from => 'complete!' );
            },
            on_warning => sub {
                warn 'Activation fail: ', $_[1];
            },
            on_fail => sub {
                warn 'fail job';
            },
        );
    }
}

__PACKAGE__->meta->make_immutable;
