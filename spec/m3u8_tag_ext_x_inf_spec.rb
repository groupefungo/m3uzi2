require_relative '../lib/m3uzi/specification/m3u8_specification'
require_relative '../lib/m3uzi/types/tag'

include M3Uzi2

describe M3Uzi2::Tag do
  before(:all) { $plt = M3Uzi2::PlaylistSpecification.new }

  describe 'EXTINF' do
    context 'is invalid' do
      it 'with a nil value' do
        tag =  M3Uzi2::Tag.new('EXTINF')
        expect(tag.valid?).to be false
      end

      it 'with a textual string value that doesnt start with a number ' do
        tag =  M3Uzi2::Tag.new('EXTINF', 'description')
        expect(tag.valid?).to be false
      end

      it 'with a string value containing an string comma string' do
        tag =  M3Uzi2::Tag.new('EXTINF', 'bad,description')
        expect(tag.valid?).to be false
      end
    end

    context 'is valid' do
      it 'with an integer value' do
        tag =  M3Uzi2::Tag.new('EXTINF', 123)
        expect(tag.valid?).to be true
      end

      it 'with a float value' do
        tag =  M3Uzi2::Tag.new('EXTINF', 10.0)
        expect(tag.valid?).to be true
        tag =  M3Uzi2::Tag.new('EXTINF', 10.01)
        expect(tag.valid?).to be true
        tag =  M3Uzi2::Tag.new('EXTINF', 10.012313)
        expect(tag.valid?).to be true
      end

      it 'with a string value containing a float' do
        tag =  M3Uzi2::Tag.new('EXTINF', '10.0')
        expect(tag.valid?).to be true
        tag =  M3Uzi2::Tag.new('EXTINF', '10.01')
        expect(tag.valid?).to be true
        tag =  M3Uzi2::Tag.new('EXTINF', '10.011234')
        expect(tag.valid?).to be true
      end

      it 'with a string value containing an integer' do
        tag =  M3Uzi2::Tag.new('EXTINF', '10')
        expect(tag.valid?).to be true
      end

      it 'with a string value containing an integer comma string' do
        tag =  M3Uzi2::Tag.new('EXTINF', '10,description')
        expect(tag.valid?).to be true
        tag =  M3Uzi2::Tag.new('EXTINF', '12110,description')
        expect(tag.valid?).to be true
      end

      it 'with a string value containing a float comma string' do
        tag =  M3Uzi2::Tag.new('EXTINF', '10.012332,description')
        expect(tag.valid?).to be true
        tag =  M3Uzi2::Tag.new('EXTINF', '40.1,description')
        expect(tag.valid?).to be true
      end
    end
  end
end
