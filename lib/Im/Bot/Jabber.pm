package Im::Bot::Jabber;
use utf8;
use Any::Moose;

use AnyEvent::XMPP::IM::Connection;

has account => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has password => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has connection => (
    is  => 'rw',
    isa => 'AnyEvent::XMPP::IM::Connection',
    handles => [qw/connect is_connected/],
);

has on_message => (
    is      => 'rw',
    isa     => 'CodeRef',
    lazy    => 1,
    default => sub { sub {} },
);

no Any::Moose;

sub BUILD {
    my $self = shift;

    my $connection = AnyEvent::XMPP::IM::Connection->new(
        jid              => $self->account,
        password         => $self->password,
    );

    $connection->reg_cb(
        error => sub {
            warn 'xmpp error: ' . $_[1]->string;
        },
        disconnect => sub {
            my ($con) = @_;
            warn 'disconnected from server';

            # reconnect after 10 seconds
            my $w; $w = AnyEvent->timer(
                after => 10,
                cb    => sub {
                    undef $w;
                    $con->connect;
                },
            );
        },
        contact_request_subscribe => sub {
            my ($con, $roster, $contact, $message) = @_;
            $contact->send_subscribed;
        },
        message => sub {
            my ($con, $msg) = @_;
            $self->on_message->($msg) if $msg->type eq 'chat' and $msg->body;
        },
    );

    $self->connection( $connection );
}

sub send_message {
    my ($self, $to, $message) = @_;

    my $msg = AnyEvent::XMPP::IM::Message->new(
        to   => $to,
        body => $message,
    );
    $msg->send( $self->connection );
}

__PACKAGE__->meta->make_immutable;
