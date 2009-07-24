package Im::API::Signup;
use Any::Moose;

extends 'Im::API';

use Im::Models;

sub signup {
    my $self = shift;
    my $args = @_ > 1 ? {@_} : $_[0];

    my ($username, $password) = @$args{qw/username password/};

    return $self->error('username and password are required')
        unless $username && $password;

    my $create_account = sub {
        my $user = models('Schema::User')->create({
            username => $username,
            password => models('::Utils')->encode_password($password),
        });
        $user->create_related('im', {});

        $user;
    };

    my $user;
    eval {
        $user = models('schema')->txn_do($create_account);
    };

    if (my $error = $@) {
        if ($error =~ /Rollback failed/) {
            die $@;
        }

        return $self->error("DB Error: $@");
    }

    if (my $cb = $args->{on_success}) {
        $cb->();
    }

    $user;
}

__PACKAGE__->meta->make_immutable;
