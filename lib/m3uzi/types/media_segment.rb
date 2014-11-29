
module M3Uzi2

  # A media segment is a special case since it is not defined as a tag -
  # rather it is a URI and preceeding tags apply to it.
  #
  # Each Media Segment is specified by a series of Media Segment tags followed
  # by a URI.  Some Media Segment tags apply to just the next
  # segment; others apply to all subsequent segments until another instance of
  # the same tag.
  #
  # A Media Segment tag MUST NOT appear in a Master Playlist.  Clients SHOULD
  # fail to parse Playlists that contain both Media Segment Tags and Master
  # Playlist tags (Section 4.3.4).
  #
  # Since it is not a tag we don't validate via the specification ...
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

    # Return ALL tags (including those in other media_segments) which will
    # apply to this media segment
    def applicable_tags(playlist = nil)
      playlist = @playlist if playlist.nil?
      fail 'Cannot find applicable_tags playlist is set' unless playlist

      return [].tap do | tmp |
        if playlist.index(self) > 0
          (playlist.index(self) - 1).downto(0).each do | i |
            #puts "################# #{i} #{playlist.item_at(i)}"
            break if playlist.item_at(i).kind_of?(MediaSegment)
            break unless MediaSegment.valid_tag?(playlist.item_at(i).name)
            tmp << playlist.item_at(i)
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
  end
end
