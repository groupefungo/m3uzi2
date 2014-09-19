
module M3Uzi2
  class MediaSegment
    attr_accessor :path,
                  :playlist

    # validate_presence should check if the file exists
    # playlist allows us to do the applicable_tags and suration
    def initialize(path, playlist = nil, validate_presence = false)
      @path = path
      @playlist = playlist
    end

    def value
      @path
    end

    def version
      1
    end

    def playlist_compatability
      0x00
    end

    def to_s
      @path
    end

    def valid?
      true
    end

    # find all tags in the playlist that apply to this media segment
    def applicable_tags

    end

    # calculate the duration of the media segment by finding the EXTING
    # tag which preceeds it.
    def duration
      fail 'Cannot infer duration unless #playlist is set' unless @playlist

      idx = @playlist.find_index(self) - 1
      if idx && (tmp = @playlist.item_at(idx)).name == 'EXTINF'
        return Float(tmp.value[0..tmp.value.index(',')-1])
      end
    end
  end
end
