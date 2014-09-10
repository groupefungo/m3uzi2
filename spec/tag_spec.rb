require_relative 'spec_helper'
require_relative '../lib/m3uzi/specification/m3u8_specification'
require_relative '../lib/m3uzi/types/tags'

include M3Uzi2

describe M3Uzi2::Tag do
  let(:plspec) { PlaylistSpecification.new }
  let(:hspec) { HeaderSpecification.new }

  describe :new do
    it 'fails if name is nil' do
      expect{Tag.new}.to raise_error StandardError
    end

    it 'a new tag can be created with any name' do
      tag = Tag.new('EXT-X-INF-BADTAG')
      expect(tag).to be_kind_of M3Uzi2::Tag
    end

    it 'a new tag can be created with a name and value' do
      tag = Tag.new('EXT-X-VERSION', 12)
      expect(tag).to be_kind_of M3Uzi2::Tag
    end

    it 'a new tag can be created with a name, value and specification' do
      tag = Tag.new('EXT-X-INF-BADTAG', 12, specification: plspec)
      expect(tag).to be_kind_of M3Uzi2::Tag
    end
  end

  describe :name do
   let(:tn) { 'EXT-X-VERSION' }
   let(:tag) { Tag.new(tn, 2, specification: hspec) }

   it 'must be set in the initializer' do
      expect(tag.name).to eq tn
   end

   it 'cannot be changed' do
      tn = 'EXT-X-VERSION'
      expect{tag.name = 'EXT-X-BYTERANGE'}.to raise_error NoMethodError
   end
  end

  describe :value do
    let(:tn) { 'EXT-X-VERSION' }
    let(:val) { 2 }
    let(:tag) { Tag.new(tn, val, specification: hspec) }

    it 'can be set in the initializer' do
      expect(tag.value).to eq 2
    end

    it 'can be changed' do
      tag.value = 200
      expect(tag.value).to eq 200
    end

    it 'fails with StandardError if there are attributes present' do
      tag1 = Tag.new('EXT-X-KEY', specification: plspec)
      tag1.add_attributes('METHOD=NONE')
      expect{tag1.value = 200}.to raise_error StandardError
    end
  end

  describe :add_attributes do
    let(:tag) { Tag.new('EXT-X-KEY') }

    it 'takes a single attr=value pair as a string and adds that attribute' do
      tag.add_attributes('METHOD=NONE')
      expect(tag.attributes['METHOD']).to be_kind_of Attribute
      expect(tag.attributes['METHOD'].value).to eq 'NONE'
    end

    it 'takes a comma seperated string of n attr=value pairs and adds those attributes' do
      tag.add_attributes('METHOD=AES-128,URI="https://priv.example.com/key.php?r=52"')
      expect(tag.attributes['METHOD']).to be_kind_of Attribute
      expect(tag.attributes['METHOD'].value).to eq 'AES-128'
      expect(tag.attributes['URI']).to be_kind_of Attribute
      expect(tag.attributes['URI'].value).to eq '"https://priv.example.com/key.php?r=52"'

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
