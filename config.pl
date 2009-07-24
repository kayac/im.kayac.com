my $home = Im::Models->get('home');

# database
my $connect_info = [
    'dbi:SQLite:' . $home->file('database.db'),
    undef, undef,
    { unicode => 1 },
];

#my $connect_info = [
#    'dbi:mysql:im', 'root', '',
#    {
#        mysql_enable_utf8 => 1,
#        on_connect_do     => ['SET NAMES utf8'],
#    },
#];

my $cache = {
    class => 'Cache::FastMmap',
    deref => 1,
    args  => {
        share_file => $home->file('tmp/session.db')->stringify,
    },
};

my $gearman = {
    job_servers => ['127.0.0.1'],
};

return {
    database => $connect_info,
    cache    => $cache,
    gearman  => $gearman,
};
