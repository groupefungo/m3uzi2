
module M3Uzi2
  # A Media Playlist contains a series of Media Segments which make up the
  # overall presentation. A Media Segment is specified by a URI and optionally
  # a byte range.

  # The duration of each Media Segment is indicated in the Media Playlist by
  # its EXTINF tag (Section 4.3.2.1).

  # Each segment in a Media Playlist has a unique integer Media Sequence
  # Number. The Media Sequence Number of the first segment in the playlist is
  # either 0, or declared in the Playlist (Section 4.3.3.2). The Media Sequence
  # Number of every other segment is equal to the Media Sequence Number of the
  # segment that precedes it plus one.

  # Each Media Segment MUST be formatted as an MPEG-2 Transport Stream
  # [ISO_13818], an MPEG audio elementary stream [ISO_11172], or a WebVTT
  # [WebVTT] file. Transport of other media file formats is not defined.

  # Some media formats require that a parser be initialized with a common
  # sequence of bytes before a Media Segment can be parsed. This format-
  # specific sequence is called the Media Initialization Section. The Media
  # Initialization Section of an MPEG-2 Transport Stream segment is the Program
  # Association Table (PAT) followed by the Program Map Table (PMT). The Media
  # Initialization Section of a WebVTT segment is the WebVTT header. An audio
  # elementary stream has no Media Initialization Section.

  # Transport Stream segments MUST contain a single MPEG-2 Program; playback of
  # Multi-Program Transport Streams is not defined. Each Transport Stream
  # segment SHOULD contain a PAT and a PMT at the start of the segment - or
  # have a Media Initialization Section declared in the Media Playlist (Section
  # 4.3.2.5). Transport Stream packets read before a corresponding PAT/PMT can
  # be discarded.

  # A Media Segment that contains video SHOULD have at least one key frame and
  # enough information to completely initialize a video decoder.

  # Each Media Segment MUST be the continuation of the encoded media at the end
  # of the segment with the previous Media Sequence Number, where values in a
  # continuous series such as timestamps and Continuity Counters continue
  # uninterrupted. The only exceptions are the first Media Segment ever to
  # appear in a Media Playlist, and Media Segments which are explicitly
  # signaled as discontinuities (Section 4.3.2.3). Unmarked media
  # discontinuities can trigger playback errors.

  # Each Elementary Audio Stream segment MUST signal the timestamp of its first
  # sample with an ID3 PRIV tag [ID3] at the beginning of the segment. The ID3
  # PRIV owner identifier MUST be
  # "com.apple.streaming.transportStreamTimestamp".
  # The ID3 payload MUST be a
  # 33-bit MPEG-2 Program Elementary Stream timestamp expressed as a big-endian
  # eight-octet number, with the upper 31 bits set to zero. An Elementary
  # Audio Stream segment without such an ID3 tag can trigger playback errors.

  # Subtitle segments are formatted as WebVTT [WebVTT] files. Each subtitle
  # segment MUST contain all subtitle cues that are intended to be displayed
  # during the period indicated by the segment EXTINF duration. The start time
  # offset and end time offset of each cue MUST indicate the total display time
  # for that cue, even if that time range extends beyond the EXTINF duration.
  # A WebVTT segment MAY contain no cues; this indicates that no subtitles are
  # to be displayed during that period.

  # Each subtitle segment MUST either start with a WebVTT header or have a
  # Media Initialization Section declared in the Media Playlist (Section
  # 4.3.2.5).

  # Within each WebVTT header there MUST be an X-TIMESTAMP-MAP metadata header.
  # This header synchronizes the cue timestamps in the WebVTT file with the
  # MPEG-2 (PES) timestamps in other Renditions of the Variant Stream. Its
  # format is:

  # X-TIMESTAMP-MAP=LOCAL:<cue time>,MPEGTS:<MPEG-2 time>
  # e.g. X-TIMESTAMP-MAP=LOCAL:00:00:00.000,MPEGTS:900000

  # The cue timestamp in the LOCAL attribute MAY fall outside the range of time
  # covered by the segment.

  # A subtitle segment not meeting these requirements can be displayed
  # inconsistently, not display at all, or cause other playback errors.

  class MediaSegment
    attr_accessor :path,
                  :playlist

    attr_accessor :specification

    def self.specification
      @_specification ||= MediaSegmentSpecification.new
    end

    def self.valid_tag?(tag)
      specification.valid_tag?(tag)
    end

    # Validate_presence should check if the file exists playlist allows us to
    # do the applicable_tags and suration
    def initialize(path, playlist = nil, validate_presence = false,
                    specification: nil)
      @path = path
      @playlist = playlist
      @segment_tags = {}

      @specification = specification
    end

    def value
      @path
    end

    # static value of 1
    def version
      1
    end

    # only compatable with media playlists
    def playlist_compatability
      0b10
    end

    def to_s
      @path
    end

    def valid?
      @path && (@segment_tags.empty? ? true : @segment_tags.all? { | s | s.valid? })
    end

    def sequence_number

    end

    # pantos_14 branch
    # BIG change to the way m3uzi2 works - a media segment now manages the
    # tags which apply to it. See specification for valid tags.

    # Return a specific tag.
    def segment_tag(tag)
      tag.kind_of?(Tag) ? @segment_tags[tag.name] : @segment_tags[tag]
    end

    # return any and all segment tags.
    def segment_tags
      @segment_tags.values ? @segment_tags.values : []
    end

    def add_segment_tag(tag)
      fail "#{tag.name} already applied to this segment" \
        unless @segment_tags[tag.name].nil?

      @segment_tags[tag.name] = tag
    end

    def clear_segment_tags
      @segment_tags.clear
    end

    def remove_segment_tag(tag)
      tag.kind_of?(Tag) ? name = tag.name : name = tag
      fail "#{name} not present" unless has_tag?(name)

      @segment_tags.delete(name)
    end

    def has_tag?(tag)
      return @segment_tags.values.include?(tag) if tag.kind_of?(Tag)
      return @segment_tags.keys.any? { | t | t == tag } \
        if tag.kind_of?(String)
      false
    end

    def self.create_segment_tag(name, atttibutes, value)
      M3Uzi2::M3U8File.create_tag(name, atttibutes, value)
    end

    # deletes the segment and all applicable tags
    def delete(playlist = nil, delete_applicable_tags: true)
      playlist = set_playlist(playlist)
      return unless (idx = playlist.index(self))

      applicable_tags(playlist).each do | tag |
        playlist.delete(tag)
      end if delete_applicable_tags

      playlist.delete(self)
    end

    def remove

    end

    # Return all tags which directly apply to this media segment.
    # TODO: add 'all' which also returns applicable key and map tags
    def applicable_tags(playlist = nil)
      playlist = @playlist if playlist.nil?
      fail 'Cannot find applicable_tags playlist is set' unless playlist

      return [].tap do | tmp |
        if playlist.index(self) > 0
          (playlist.index(self) - 1).downto(0).each do | i |
            break if playlist.item_at(i).kind_of?(MediaSegment)

            tmp << playlist.item_at(i) \
              if MediaSegment.valid_tag?(playlist.item_at(i).name)
          end
        end
      end
    end

    # calculate the duration of the media segment by finding the EXTINF
    # tag which preceeds it.
    def duration
      fail 'Cannot calculate duration unless #playlist is set' unless @playlist

      idx = @playlist.find_index(self) - 1
      if idx && (tmp = @playlist.item_at(idx)).name == 'EXTINF'
        return Float(tmp.value[0..tmp.value.index(',') - 1])
      end
    end

    private

    def set_playlist(playlist)
      playlist = @playlist if playlist.nil?
      fail 'Cannot find applicable_tags playlist is set' unless playlist
      playlist
    end

  end
end
