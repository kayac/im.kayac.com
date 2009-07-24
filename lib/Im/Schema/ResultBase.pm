package Im::Schema::ResultBase;
use strict;
use warnings;
use base 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);

sub sqlt_deploy_hook {
    my ($self, $sqlt_table) = @_;

    $sqlt_table->extra(
        mysql_table_type => 'InnoDB',
        mysql_charset    => 'utf8',
    );
}

1;
