require_relative '../lib/m3uzi/specification/m3u8_specification'
require_relative '../lib/m3uzi/types/tag'

include M3Uzi2

describe M3Uzi2::Tag do

  # Mocking the specification would simplify things however it would
  # also fail to go to the core of the code in testing that the tags
  # conform to the specification.
  before(:all) { $plt = M3Uzi2::PlaylistSpecification.new }

  describe 'An Invalid Tag' do
    it 'valid? is false' do
      tag =  M3Uzi2::Tag.new('EXT-X-INF-BADTAG', 123)
      expect(tag.valid?).to be false
    end
  end

  describe 'EXT-X-KEY' do
    let(:tag) { M3Uzi2::Tag.new('EXT-X-KEY') }

    it 'is valid with a nil value' do
      expect(tag.valid?).to be true
    end

  end

end
