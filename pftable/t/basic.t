#!/usr/bin/env perl

use warnings;
use strict;

use Test::More tests => 2;
use FindBin;
use lib "$FindBin::Bin/..";

use PFTable qw(add);

is( add( 2,  3 ), 5,  'add returns correct sum' );
is( add( -1, 1 ), 0,  'add handles negative numbers' );
