package Im::Schema::Result::ImAccount;
use strict;
use warnings;
use utf8;
use base qw/Im::Schema::ResultBase/;

use Im::Models;

__PACKAGE__->table('im_account');
__PACKAGE__->add_columns(
    id => {                     # == user.id
        data_type   => 'INTEGER',
        is_nullable => 0,
        extra => {
            unsigned => 1,
        },
    },
    service => {
        data_type   => 'VARCHAR',
        is_nullable => 1,
        size        => 255,
    },
    username => {
        data_type   => 'VARCHAR',
        is_nullable => 1,
        size        => 255,
    },
    valid => {
        data_type     => 'INTEGER',
        size          => 1,
        default_value => 0,
        extra => {
            unsigned => 1,
        },
    },
    validation_code => {
        data_type   => 'VARCHAR',
        is_nullable => 1,
        size        => 40,
    },
    authentication => {
        data_type     => 'ENUM',
        default_value => 'no',
        extra => {
            list => [qw/no password secretkey/],
        },
    },
    authentication_code => {
        data_type   => 'VARCHAR',
        is_nullable => 1,
        size        => 255,
    },
);
__PACKAGE__->set_primary_key(qw/id/);

__PACKAGE__->has_one( user => 'Im::Schema::Result::User' );

sub address {
    my ($self) = @_;

    my $address = $self->username;
    if ($self->service eq 'gtalk' and $address !~ /\@/) {
        $address .= '@gmail.com';
    }

    $address;
}

sub update_from_form {
    my ($self, $form) = @_;

    $self->set_columns({
        service  => $form->valid_param('im'),
        username => $form->valid_param('account'),
    });
    my $account_changed = $self->is_changed;

    my $auth_type = $form->valid_param('auth');
    $self->set_columns({
        authentication      => $auth_type,
        authentication_code => $form->valid_param($auth_type) || undef,
    });

    if ($account_changed) {     # require validation
        my $code = models('::Utils')->create_unique_id;
        $self->set_columns({
            valid           => 0,
            validation_code => $code,
        });
    }

    $self->update if $self->is_changed;

    return $self;
}

sub activate {
    my ($self, $code) = @_;

    return if $self->valid;

    if ($self->validation_code eq $code) {
        $self->update({ valid => 1 });
        return 1;
    }
    return;
}

sub reset {
    my $self = shift;

    $self->update({
        service             => undef,
        username            => undef,
        valid               => 0,
        validation_code     => undef,
        authentication      => 'no',
        authentication_code => undef,
    });
}

1;
