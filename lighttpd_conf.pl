#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;

print <<"...";
server.document-root = "$FindBin::Bin/root"

\$HTTP["url"] !~ "^/(css/|js/|imgs?/|images?/|static/|swf/|[^/]+\\.[^/]+\$)" {
    fastcgi.server = (
        "" => (
            ( "socket"      => "$FindBin::Bin/tmp/fastcgi.socket",
              "check-local" => "disable", ),
        ),
    )
}

...
