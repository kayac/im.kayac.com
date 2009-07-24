use Test::Base;
use Im::Models;

my $utils = models('::Utils');

{
    # create_unique_id
    my $id = $utils->create_unique_id;
    is length($id), 40, '$id ok';

    my $id2 = $utils->create_unique_id;
    is length($id2), 40, '$id2 ok';

    isnt $id, $id2, '$id != $id2 ok';
}

{
    # sha1_hex
    is $utils->sha1_hex('foo'), Digest::SHA1::sha1_hex('foo'), 'sha1_hex ok';
}

{
    # encode_password
    my $pre = 'pre';
    my $pos = 'post';

    my $conf = models('conf');
    $conf->{password_pre_salt} = $pre;
    $conf->{password_post_salt} = $pos;

    is $utils->encode_password('my_password'),
        Digest::SHA1::sha1_hex($pre . 'my_password' . $pos), 'encode_password ok';
}

Test::More::done_testing;

