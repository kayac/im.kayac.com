package Im::API::Post;
use Any::Moose;

extends 'Im::API';

use utf8;
use Encode;
use Im::Models;

no Any::Moose;

sub post {
    my $self = shift;
    my $args = @_ > 1 ? {@_} : $_[0];

    my $username  = $args->{username};
    my $message   = $args->{message};
    my $password  = $args->{password} || '';
    my $signature = $args->{sig} || '';

    return $self->error('username is empty')
        unless $username;

    return $self->error('message is empty')
        unless $message;

    my $user = models('Schema::User')->single({ username => $username });
    unless ($user and $user->im->valid) {
        return $self->error(qq[Invalid account "$username", please activate account before using this API]);
    }

    my $im_setting = $user->im;
    if ($im_setting->authentication eq 'password') {
        # For security reason, don't include auth-type in error messages
        return $self->error('authorization required')
            unless $im_setting->authentication_code eq $password;
    }
    elsif ($im_setting->authentication eq 'secretkey') {
        return $self->error('authorization required')
            unless $signature;

        my $hash = models('::Utils')->sha1_hex(
            encode_utf8( $message . $im_setting->authentication_code ),
        );

        return $self->error('authorization required')
            unless $hash eq $signature;
    }

    my $res = models('jsonrpc')->call(
        send_message => $im_setting->address => $message,
    );

    if ($res) {
        return $res->result;
    }
    else {
        warn 'JSONRPC Server error: ' . models('jsonrpc')->error;
        return $self->error('Internal Server Error');
    }
}

__PACKAGE__->meta->make_immutable;
