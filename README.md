M3Uzi2
======

This started life as a simple bug fix of M3uzi but ended up becoming such a
major rewrite that there is very little of the original m3uzi remaining.

- Read and write M3U(8) files.
- Validate files and tags against version 7 of the specifiction.
  (http://tools.ietf.org/html/draft-pantos-http-live-streaming-13)

Usage
------

Read an M3U file:

  m3u = M3Uzi2::M3U8File.new("path/to/file")
  m3u_reader = M3Uzi2::M3U8Reader.new(m3u)
  m3u_reader.read

Write an M3U file:

  m3u_writer =
    m3u.write("/path/to/file.m3u8")

Get a list of media segments:

    m3u.media_segements

Add a file to the M3U index:

    m3u.add_file do |file|
      file.path = "/path/to/file.ts"
      file.duration = 10
      file.description = "no desc"
    end

Get all tag reference objects:

    m3u.tags

Get an individual tag value (TARGETDURATION MEDIA-SEQUENCE ALLOW-CACHE STREAM-INF ENDLIST VERSION):

    m3u[:targetduration]
    m3u[:media_sequence]

Set an individual tag value:

    m3u[:targetduration] = 100

Add a tag to the M3U index (custom tags even):

    m3u.add_tag do |tag|
      tag.name = "VERSION"
      tag.value = "1"
    end

NOTES
------
* Target duration will be calculated and included if omitted


TODO
-----

(c) 2010 Brandon Arbini / Zencoder, Inc.
