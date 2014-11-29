require_relative 'spec_helper'
require_relative '../lib/m3uzi/specification/m3u8_specification'
require_relative '../lib/m3uzi/types/attributes'

include M3Uzi2

describe Attributes do
  let(:plspec) { M3Uzi2::MediaPlaylistSpecification.new }
  let(:tag) { M3Uzi2::Tag.new('EXT-X-KEY', specification: plspec) }

  it 'is a kind of hash' do
    expect(Attributes.new).to be_kind_of Hash
  end

  describe 'Attributes.parse' do
    let(:result) do Attributes.parse(
      'KEY=VALUE,NUM="1",VAL="1,2,3",URI="http://sum.com/k=v"')
    end

    it 'fails if and element is not of the form k=v' do
      expect do
        Attributes.parse('KEY=VALUE,NUM="1",VAL,URI="http://sum.com/k=v"')
      end.to raise_error StandardError
    end

    it 'returns an array' do
      expect(result).to be_kind_of Array
    end

    it 'returns 1 array element for each k=v pair in the string' do
      expect(result.size).to eq 4
    end

    describe 'each element of the array' do
      it 'contains an array' do
        expect(result[0]).to be_kind_of Array
        expect(result[1]).to be_kind_of Array
        expect(result[2]).to be_kind_of Array
        expect(result[3]).to be_kind_of Array
      end

      it 'contains the key in the first element' do
        expect(result[3][0]).to eq 'URI'
      end

      it 'contains the value in the second' do
        expect(result[3][1]).to eq '"http://sum.com/k=v"'
      end
    end
  end
end

describe Attribute do
  let(:parent) { double("Tag") }

  it 'requires the parent_tag and name in the initilize method' do
    attr = Attribute.new(parent, 'CODEC')
    expect(attr).to be_kind_of Attribute
    expect(attr.name).to eq 'CODEC'
  end

  describe :parent_tag do
    let(:attr) { Attribute.new(parent, 'CODEC') }
    it 'must be set in the initializer' do
      expect(attr.parent_tag).to be parent
    end

    it 'cannot be changed' do
      expect { attr.parent=nil }.to raise_error NoMethodError
    end

  end

  describe :value do
    let(:attr) { Attribute.new(parent, 'CODEC', '1234') }
    it 'can be set in the initializer' do
      expect(attr.value).to eq '1234'
    end
    it 'can be changed' do
      attr.value='5678'
      expect(attr.value).to eq '5678'
    end
  end

  it 'provides a #parent_attribute which is a shortcut to get an'\
     'attribute of the parent by name' do
    # it just is
  end

  it 'provides a #valid? method which checks the attribute against the'\
     'specification' do
    spec = double("Specifification")
    tag = double('Tag')

    expect(tag).to receive(:specification) { spec }
    expect(spec).to receive(:check_attribute)

    attr =  Attribute.new(tag, 'CODEC', 'abc123')
    attr.valid?
  end

  describe :to_s do
    let(:attr) { Attribute.new(parent, 'CODEC', '1234') }
    it 'has a #to_s method which returns the a/v pairs as a string' do
      expect(attr.to_s).to eq 'CODEC=1234'
    end
  end
end
