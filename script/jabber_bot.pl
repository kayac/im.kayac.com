#!/usr/bin/env perl

use strict;
use warnings;
use FindBin::libs;

use Im::Bot;
use Im::Models;

my $bot = Im::Bot->new(models('conf'));
$bot->start;

