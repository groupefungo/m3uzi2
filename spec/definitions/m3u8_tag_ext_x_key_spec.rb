require_relative '../../lib/m3uzi/specification/m3u8_specification'
require_relative '../../lib/m3uzi/types/tags'

include M3Uzi2

describe M3Uzi2::Tag do

  # Mocking the specification would simplify things however it would
  # also fail to go to the core of the code in testing that the tags
  # conform to the specification.
  let(:plspec) { M3Uzi2::MediaPlaylistSpecification.new }

  describe 'EXT-X-KEY' do
    let(:tag) { M3Uzi2::Tag.new('EXT-X-KEY', specification: plspec) }

    #context 'is invalid' do
      #it 'without a METHOD attribute' do
        #expect(tag.valid?).to be false
      #end

      #context 'when METHOD is NONE' do
        #it 'and URI is present' do
          #tag.add_attribute('METHOD', 'NONE')
          #tag.add_attribute('URI', 'http://somewhere.com')
          #expect(tag.valid?).to be false
        #end
      #end

      #context 'when METHOD is AES-128 or SAMPLE-AES' do
        #it 'and URI is missing' do
          #tag.add_attribute('METHOD', 'AES-128')
          #expect(tag.valid?).to be false
          #tag.add_attribute('METHOD', 'SAMPLE-AES')
          #expect(tag.valid?).to be false
        #end
      #end
    #end

    context 'it is valid' do
      describe 'with a METHOD attribute' do
        it ' which accepts value of NONE' do
          tag.add_attribute('METHOD', 'NONE')
          expect(tag.valid?).to be true
        end

        it ' which accepts value of NONE and must not have a URI' do
          tag.add_attribute('METHOD', 'NONE')
          tag.add_attribute('URI', 'http://somewhere.com')
          expect(tag.valid?).to be false
        end

        it ' which accepts value of AES 128' do
          tag.add_attribute('METHOD', 'AES-128')
          tag.add_attribute('URI', 'http://somewhere.com')
          expect(tag.valid?).to be true
        end

        it ' which accepts value of SAMPLE-AES' do
          tag.add_attribute('METHOD', 'SAMPLE-AES')
          tag.add_attribute('URI', 'http://somewhere.com')
          expect(tag.valid?).to be true
        end

        it 'is invalid unless one of those' do
          tag.add_attribute('METHOD', 'fred')
          expect(tag.valid?).to be false
        end




      end
    end
  end
end
