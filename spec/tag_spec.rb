require_relative '../lib/m3uzi/specification/m3u8_specification'
require_relative '../lib/m3uzi/types/tags'

include M3Uzi2

describe M3Uzi2::Tag do

  # Mocking the specification would simplify things however it would
  # also fail to go to the core of the code in testing that the tags
  # conform to the specification.
  let(:plspec) { PlaylistSpecification.new }
  let(:hspec) { HeaderSpecification.new }

  context 'A Tag name not used in the specification' do
    it 'new returns nil' do
      tag = Tag.new('EXT-X-INF-BADTAG', 123, specification: plspec)
      expect(tag).to be nil
    end
  end

  describe :name do
   it 'must be set in the initializer' do
   end

   it 'cannot be changed' do 
   end
  end

  describe :value do
    it 'can be set in the initializer' do

    end

    it 'can be changed' do 
    end

    it 'fails with StandardError if there are attributes present' do
    end
  end

  describe :add_attributes do
    it 'takes a single attr=value pair as a string and adds that attribute' do

    end

    it 'takes a comma seperated string of n attr=value pairs and adds those attributes' do
    end

    context 'it is an EXT-X-I-FRAME-STREAM tag' do
      it 'correctly parses the CODECS attribute' do
      end
    end
  end

  describe :add_attribute do
    it 'takes a name and value parameter, adding as an attribute' do
    end 
    
    it 'fails with StandardError if a value has been set' do  
    end
  end

  describe :[] do
   it 'returns nil if the attribute +key+ is not present' do
   end

   it 'returns the attribute value if +key+ is present' do
   end
  end
 
  describe :[]= do
    it 'sets the attribute specified by +key+ to the given value' do
    end

    it 'fails with StandardError if a value has been set' do  
    end
  end

  describe :valid? do
   it 'returns true if the tag and all attributes are valid' do
   end
  end

  describe :version do
    it 'returns the specification version in which the tag first was used' do
    end
  end

  describe :playlist_compatability do
    it 'returns an integer corresponding with the type of playlist the tag can be used in' do
    end
  end

  def valid_occurance_range
    it 'returns a range specifying the min and max number of times the tag can appear in a playlist' do
    end
  end
end
