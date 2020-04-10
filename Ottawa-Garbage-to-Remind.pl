#!/usr/bin/perl

use strict;
use warnings;

use lib "/path/to/lib/";
use ICS;

use LWP::UserAgent;

# Go to the following url: 
# https://ottawa.ca/en/garbage-and-recycling/garbage#garbage-and-recycling-collection-calendar
# Search your address. Select "Get a Calendar", Select "Add to Google Calendar", replace the following with your link:
my $url = "https://recollect.a.ssl.fastly.net/api/places/<GUID>/services/208/events.en.ics?client_id=<GUID>";
my $out = "/path/to/garbage.rem";

my $ua = LWP::UserAgent->new();
my $raw = $ua->get($url)->content();

my $ics = ICS->new();
my $ics_ref = $ics->decode($raw);

open (my $fh, ">", $out) || die "Couldn't open output file $out\n";
foreach (@{$ics_ref->{VCALENDAR}->{VEVENT}}) {
    $_->{SUMMARY} =~ s/, and yard trimmings$//;
    $_->{'DTSTART;VALUE=DATE'} =~ s/(\d{4})(\d{2})(\d{2})/$1-$2-$3/;
    print $fh "REM $_->{'DTSTART;VALUE=DATE'} AT 07:00 TAG GARBAGE MSG $_->{SUMMARY}\n";
}
close $fh;
