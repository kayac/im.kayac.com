package Im::Schema::Result::User;
use strict;
use warnings;
use base qw/Im::Schema::ResultBase/;

__PACKAGE__->table('user');

__PACKAGE__->add_columns(
    id => {
        data_type         => 'INTEGER',
        is_nullable       => 0,
        is_auto_increment => 1,
        extra => {
            unsigned => 1,
        },
    },
    username => {
        data_type   => 'VARCHAR',
        size        => 255,
        is_nullable => 0,
    },
    password => {
        data_type   => 'VARCHAR',
        size        => 40,
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(['username']);

__PACKAGE__->has_one( im => 'Im::Schema::Result::ImAccount' );

1;

