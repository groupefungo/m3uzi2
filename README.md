M3Uzi2
======

[![Code Climate](https://codeclimate.com/github/os6sense/m3uzi2/badges/gpa.svg)](https://codeclimate.com/github/os6sense/m3uzi2)
[![Build Status](https://travis-ci.org/os6sense/m3uzi2.svg?branch=master)](https://travis-ci.org/os6sense/m3uzi2)
[![Test Coverage](https://codeclimate.com/github/os6sense/m3uzi2/badges/coverage.svg)](https://codeclimate.com/github/os6sense/m3uzi2)

Unfinished, incomplete tests, not a version 1.0.0 despite what the version says!

This started life as a simple bug fix of M3uzi but ended up becoming such a
major rewrite that there is very little (if any!) of the original m3uzi remaining. 

- Read and write M3U(8) files.

- Validate files and tags against version 6 of the specifiction.
  (http://tools.ietf.org/html/draft-pantos-http-live-streaming-13)
  ** partial support - still need to add various attribute constraints.

- Handle live streaming.

I'm still working on the client which actually uses this gem hence patches/issues are WELCOME!
Usage
------

Read an M3U file:

Write an M3U file:

Get a list of media segments:

Add a file to the M3U index:

Get all tag reference objects:

Get a tag value :

Set an individual tag value:

Add a tag to the M3U index :


NOTES
------
* Target duration will be calculated and included if omitted


TODO
-----

