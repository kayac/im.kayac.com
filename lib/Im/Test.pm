package Im::Test;
use Ark 'Test';

use File::Temp qw/tempdir/;
use Im::Models;

sub import {
    my ($class, $app, %options) = @_;
    $app ||= 'Im';

    # mocked database
    {
        my $dir = tempdir( CLEANUP => 1 );

        models('conf')->{database} = [
            "dbi:SQLite:$dir/database.db", undef, undef,
            { unicode => 1, ignore_version => 1 },
        ];
        models('schema')->deploy;
    }

    @_ = ($class, $app, %options);
    goto $class->can('SUPER::import');
}

1;
