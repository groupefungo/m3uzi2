require_relative '../../lib/m3uzi/specification/m3u8_specification'
require_relative '../../lib/m3uzi/types/tags'

include M3Uzi2

describe 'EXT-X-ALLOW-CACHE' do
  let(:spec) { M3Uzi2::HeaderSpecification.new }
  let(:tag) { M3Uzi2::Tag.new('EXT-X-ALLOW-CACHE', specification: spec) }

  it 'is valid with a value of YES' do
    tag.value = 'YES'
    expect(tag.valid?).to be true
  end

  it 'is valid with a value of NO' do
    tag.value = 'NO'
    expect(tag.valid?).to be true
  end

  it 'is valid with a nil value' do
    tag.value = nil
    expect(tag.valid?).to be false
  end

  it 'is valid with an empty string value' do
    tag.value = ''
    expect(tag.valid?).to be false
  end
end
