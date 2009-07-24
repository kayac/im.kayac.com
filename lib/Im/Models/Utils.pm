package Im::Models::Utils;
use Mouse;
use Im::Models;

sub create_unique_id {
    my $self = shift;
    my $uuid = models('uuid');

    $self->sha1_hex( $uuid->create );
}

sub sha1_hex {
    my ($self, $str) = @_;
    my $sha1 = models('sha1');

    $sha1->add( $str );
    my $hash = $sha1->hexdigest;
    $sha1->reset;

    $hash;
}

sub encode_password {
    my ($self, $password) = @_;

    my $sha1 = models('sha1');
    my $conf = models('conf');

    my $pre_salt  = $conf->{password_pre_salt} || '';
    my $post_salt = $conf->{password_post_salt} || '';

    $sha1->add($pre_salt);
    $sha1->add($password);
    $sha1->add($post_salt);

    my $hashed = $sha1->hexdigest;

    $sha1->reset;

    $hashed;
}

1;
