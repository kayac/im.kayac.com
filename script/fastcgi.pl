#!/usr/bin/env perl

use strict;
use warnings;
use FindBin::libs;

use Getopt::Long;

use Im;
use HTTP::Engine;

GetOptions(
    \my %options,
    qw/keep_stderr detach nproc=i pidfile=s listen=s/,
);

my $app = Im->new;
$app->setup;

HTTP::Engine->new(
    interface => {
        module          => 'FCGI',
        args            => \%options,
        request_handler => $app->handler,
    },
)->run;

