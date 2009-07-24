package Im::Schema::ResultSet::User;
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

use Im::Models;

sub create_new_user {
    my ($rs, $attr) = @_;
    my $schema = $rs->result_source->schema;

    # hash password
    $attr->{password} = models('utils')->encode_password($attr->{password});

    my $create_user_and_imaccount = sub {
        my $new_user = $rs->create($attr) or die $!;
        $rs->related_resultset('im')->create({
            id => $new_user->id,
        }) or die $!;

        return $new_user;
    };

    my $user;
    eval { $user = $schema->txn_do($create_user_and_imaccount) };
    die $@ if $@;

    $user;
}

1;

