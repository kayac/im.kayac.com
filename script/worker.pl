#!/usr/bin/env perl

use strict;
use warnings;
use FindBin::libs;
use utf8;

use Im::Models;
use Gearman::Worker;

my $worker = Gearman::Worker->new;
$worker->job_servers('127.0.0.1:4730');

$worker->register_function( activate => sub {
    my $job  = shift;
    my $args = models('json')->decode($job->arg);

    my $code = $args->{code} or return $job->fail;

    my $account = models('Schema::ImAccount')->single({ validation_code => $code });
    unless ($account and $args->{address} eq $account->address) {
        die qq[no such account connected to "$code"];
    }

    if ($account->activate($code)) {
        return $account->address;
    }
    else {
        die 'activate failed or already activated';
    }
});

my $alive = 1;

$SIG{TERM} = sub {
    $alive = 0;
};

$worker->work while $alive;


