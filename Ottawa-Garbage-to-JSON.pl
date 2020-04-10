#!/usr/bin/perl

use strict;
use warnings;
use JSON::XS;

use lib "/path/to/lib/";
use ICS;

use LWP::UserAgent;

# Go to the following url: 
# https://ottawa.ca/en/garbage-and-recycling/garbage#garbage-and-recycling-collection-calendar
# Search your address. Select "Get a Calendar", Select "Add to Google Calendar", replace the following with your link:
my $url = "https://recollect.a.ssl.fastly.net/api/places/<GUID>/services/208/events.en.ics?client_id=<GUID>";

my $ua = LWP::UserAgent->new();
my $raw = $ua->get($url)->content();

my $ics = ICS->new();
my $ics_ref = $ics->decode($raw);

my $json = JSON::XS->new();
print $json->pretty(1)->encode($ics_ref);
