# Perl-ICS-Tools
Primitive Parser and Tools for Dealing With iCal Files

## What this does

Takes input as raw ICS data and outputs a Hash Reference with nested arrays and hashes for events, reminders and other properties.

Nesting occurs at every "BEGIN" statement. Objects which are allowed to appear more than once according to the iCal specifications will be added as an array, other properties will be scalars. Simple example output converted to JSON:

```
{
   "VCALENDAR" : {
      "X-WR-CALDESC" : "Solid Waste and Recycling",
      "PRODID" : "Data::ICal 0.23",
      "X-PUBLISHED-TTL" : "1440",
      "METHOD" : "PUBLISH",
      "VERSION" : "2.0",
      "X-WR-CALNAME" : "<redacted address>, Ottawa, Ontario, Canada",
      "X-WR-TIMEZONE" : "America/Toronto",
      "VEVENT" : [
         {
            "SUMMARY" : "Garbage, blue bin, green bin, and yard trimmings",
            "DESCRIPTION" : "Garbage, blue bin, green bin, and yard trimmings",
            "UID" : "2020-03-27-Ottawa-waste-@recollect.net",
            "DTSTART;VALUE=DATE" : "20200327"
         },
         {

            "SUMMARY" : "Black bin, green bin, and yard trimmings",
            "UID" : "2020-12-26-Ottawa-waste-@recollect.net",
            "DESCRIPTION" : "Black bin, green bin, and yard trimmings",
            "DTSTART;VALUE=DATE" : "20201226"
         }
      ]
   }
}
```

## Why it is primitive

Ideally, a proper parser would do a lot of other things:

* Validate the the input
  * This module doesn't even know what to do if a line has neither a leading space or a colon.
  * It doesn't check proper syntax.
  * It doesn't check for required fields.
  * It doesn't check for illegal fields.
* Encode as well as decode
* Understand and handle property options (eg. DTSTART;VALUE=DATE)

## Will you be improving these things?

Probably not anytime soon.

Validating input would require a greater awareness of the entire tree structure and [a lot of rules for which properties are required or prohibited under which conditions](https://upload.wikimedia.org/wikipedia/commons/c/c0/ICalendarSpecification.png).

I centralize all of my calendaring in [Remind](https://dianne.skoll.ca/projects/remind/), so I don't have much need to encode as ICS. This would be relatively simple if I didn't do any validation here either, but not validating on export is a much more egregious omission.

I most created the repo because I wanted a simple tool to import events into my Remind calendar and ended up being quite satisfied with the recursive algorithm for writing arbitrary nesting structures.
