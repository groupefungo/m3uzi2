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

There are a few ways to use the main components - the most basic is to include
M3Uzi2 


Read an M3U8 file:

    m3u8 = M3Uzi2.new('../spec/samples/valid/2014-08-18-122730.M3U8')

Write an M3U8 file:
    
    m3u8.save('../spec/samples/valid/2014-08-18-122730.COPY.M3U8')

Write to a stream:

  m3u8.write_io_stream(stream = StringIO.new)

Get a list of media segments:

    m3u8.media_segments

Get a single media segment by name:

    m3u8.media_segment['something.ts']

Add a media segment:

Get all tag reference objects:

Get a tag value:

Set an individual tag value:

Add a tag to the M3U index :

Check if a file is valid:

  m3u8.valid?   

Create a sliding window:

    m3u8.slide!

Note that this is currently a shebang method and the in memory content will be altered.


NOTES
------
* Target duration will be calculated and included if omitted


TODO
-----

