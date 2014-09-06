require_relative '../../lib/m3uzi/specification/m3u8_specification'
require_relative '../../lib/m3uzi/types/tags'

include M3Uzi2

describe M3Uzi2::Tag do
  let(:spec) { M3Uzi2::HeaderSpecification.new }
  let(:plspec) { M3Uzi2::PlaylistSpecification.new }

  describe 'EXTINF' do
    context 'is invalid' do
      it 'with a nil value' do
        tag =  M3Uzi2::Tag.new('EXTINF', specification: plspec)
        expect(tag.valid?).to be false
      end

      it 'with a textual string value that doesnt start with a number ' do
        tag =  M3Uzi2::Tag.new('EXTINF', 'description', specification: plspec)
        expect(tag.valid?).to be false
      end

      it 'with a string value containing an string comma string' do
        tag =  M3Uzi2::Tag.new('EXTINF', 'bad,description', specification: plspec)
        expect(tag.valid?).to be false
      end
    end

    context 'is valid' do
      it 'with an integer value' do
        tag =  M3Uzi2::Tag.new('EXTINF', 123, specification: plspec)
        expect(tag.valid?).to be true
      end

      it 'with a float value' do
        tag =  M3Uzi2::Tag.new('EXTINF', 10.0, specification: plspec)
        expect(tag.valid?).to be true
        tag =  M3Uzi2::Tag.new('EXTINF', 10.01, specification: plspec)
        expect(tag.valid?).to be true
        tag =  M3Uzi2::Tag.new('EXTINF', 10.012313, specification: plspec)
        expect(tag.valid?).to be true
      end

      it 'with a string value containing a float' do
        tag =  M3Uzi2::Tag.new('EXTINF', '10.0', specification: plspec)
        expect(tag.valid?).to be true
        tag =  M3Uzi2::Tag.new('EXTINF', '10.01', specification: plspec)
        expect(tag.valid?).to be true
        tag =  M3Uzi2::Tag.new('EXTINF', '10.011234', specification: plspec)
        expect(tag.valid?).to be true
      end

      it 'with a string value containing an integer' do
        tag =  M3Uzi2::Tag.new('EXTINF', '10', specification: plspec)
        expect(tag.valid?).to be true
      end

      it 'with a string value containing an integer comma string' do
        tag =  M3Uzi2::Tag.new('EXTINF', '10,description', specification: plspec)
        expect(tag.valid?).to be true
        tag =  M3Uzi2::Tag.new('EXTINF', '12110,description', specification: plspec)
        expect(tag.valid?).to be true
      end

      it 'with a string value containing a float comma string' do
        tag =  M3Uzi2::Tag.new('EXTINF', '10.012332,description', specification: plspec)
        expect(tag.valid?).to be true
        tag =  M3Uzi2::Tag.new('EXTINF', '40.1,description', specification: plspec)
        expect(tag.valid?).to be true
      end
    end
  end
end
