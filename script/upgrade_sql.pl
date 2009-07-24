#!/usr/bin/env perl

use strict;
use warnings;
use FindBin::libs;
use Path::Class qw/file/;

use Im::Schema;

my $current_version = Im::Schema->schema_version;
my $next_version    = $current_version + 1;

Im::Schema->connect->create_ddl_dir(
    [qw/SQLite MySQL/],
    $next_version,
    "$FindBin::Bin/../sql/",
);

{   # replace version
    my $f = file( $INC{'Im/Schema.pm'} );
    my $content = $f->slurp;
    $content =~ s/(\$VERSION\s*=\s*(['"]))(.+?)\2/$1$next_version$2/
        or die "Failed to replace version.";

    my $fh = $f->openw or die $!;
    print $fh $content;
    $fh->close;
}
