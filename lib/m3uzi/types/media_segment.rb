
module M3Uzi2
  class MediaSegment
    attr_accessor :path # path, filename or URI

    # validate_presence should check if the file exists
    def initialize(path, validate_presence = false)
      @path = path
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
  end
end
