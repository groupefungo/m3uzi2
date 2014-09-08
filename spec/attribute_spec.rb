require_relative '../lib/m3uzi/specification/m3u8_specification'
require_relative '../lib/m3uzi/types/attributes'

include M3Uzi2

describe Attributes do
  let(:plspec) { M3Uzi2::PlaylistSpecification.new }
  let(:tag) { M3Uzi2::Tag.new('EXT-X-KEY', specification: plspec) }

  it 'is a kind of hash' do
    # expect(tag.valid?).to be false
    pending
  end

  it 'will parse a string of multiple attribute/value pairs' do
    pending

  end

  it 'will parse a string with a single attribute/value pair' do
    pending

  end

  it 'has a #to_s method which returns the a/v pairs as a string' do
    pending

  end

  describe Attribute do
    it 'requires the parent_tag and name in the initilize method' do
      pending
    end

    it 'provides a #parent_attribute which is a shortcut to get an'\
       'attribute of the parent by name' do
      pending
    end

    it 'provides a #valid? method which checks the attribute against the'\
       'specification' do
      pending
    end

    it 'returns the attribute as a string using a equals sign to seperate'\
       ' the name and value' do
      pending
    end
  end
end
