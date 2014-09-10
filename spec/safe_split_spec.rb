require_relative 'spec_helper'

require_relative '../lib/m3uzi/safe_split'

# Yes, I know, very busy tests.

include SafeSplit

describe :restore_split do
  it 'creates an array, ignoring quotes' do
    expect(restore_split('hello=world', '=')[0]).to eq 'hello'
    expect(restore_split('hello=world', '=')[1]).to eq 'world'
    expect(restore_split('hello=world,dog=cat', ',')[0]).to eq 'hello=world'
    expect(restore_split('hello=world,dog=cat', ',')[1]).to eq 'dog=cat'
    expect(restore_split('"hello=world"', '=')[0]).to eq '"hello=world"'
    expect(restore_split('"hello=world","dog=cat"', ',')[0]).to eq '"hello=world"'
    expect(restore_split('"hello=world","dog=cat"', ',')[1]).to eq '"dog=cat"'
  end
end

describe :safe_split do
  context 'when there are no values in quotation marks' do
    it 'returns an empty array if given an empty string' do
      expect(safe_split('')[0]).to eq nil
      expect(safe_split('').size).to eq 0
    end

    it 'returns an array with a single value if the seperator char is '\
       'not present' do
      expect(safe_split('METHOD=NONE')[0]).to eq %w(METHOD NONE)
    end

    it 'returns an array with multiple elements split via the sperator' do
      expect(safe_split('BANDWIDTH=65000,PROGRAM-ID=1')[0]).to \
        eq %w(BANDWIDTH 65000)
      expect(safe_split('BANDWIDTH=65000,PROGRAM-ID=1')[1]).to \
        eq %w(PROGRAM-ID 1)
    end
  end

  def basic_expectations(result)
    expect(result[0][0]).to eq 'TYPE'
    expect(result[0][1]).to eq 'AUDIO'
    expect(result[1][0]).to eq 'GROUP-ID'
    expect(result[1][1]).to eq '"aac"'
    expect(result[2][0]).to eq 'NAME'
    expect(result[2][1]).to eq '"English"'
    expect(result[3][0]).to eq 'DEFAULT'
    expect(result[3][1]).to eq 'YES'
  end

  it 'splits a line where one or more of the attr/val pairs contain commas in'\
     'quotation marks' do
    result = safe_split('TYPE=AUDIO,GROUP-ID="aac",NAME="English",DEFAULT=YES')
    basic_expectations result

    result = safe_split('TYPE=AUDIO,GROUP-ID="aac",NAME="English",DEFAULT=YES'\
                        ',CODECS="first,second,etc"')
    basic_expectations result
    expect(result[4][0]).to eq 'CODECS'
    expect(result[4][1]).to eq '"first,second,etc"'

    result = safe_split('TYPE=AUDIO,GROUP-ID="aac",NAME="English",DEFAULT=YES'\
                        ',CODECS="first,second,etc",CODECS="4th,5th,6"')
    basic_expectations result
    expect(result[4][0]).to eq 'CODECS'
    expect(result[4][1]).to eq '"first,second,etc"'
    expect(result[5][0]).to eq 'CODECS'
    expect(result[5][1]).to eq '"4th,5th,6"'
  end

  it 'splits a line with multiple values in quotation marks' do
    result = safe_split('METHOD=AES-128,URI="http://live.cdn.antel.net.uy/'\
                        'elemental.key?x=52",CODECS="first,second,etc"'\
                        ',KEYFORMATVERSIONS="1/2/3"')
    expect(result[1][0]).to eq 'URI'
    expect(result[1][1]).to eq '"http://live.cdn.antel.net.uy/elemental.key?x=52"'
    expect(result[2][0]).to eq 'CODECS'
    expect(result[2][1]).to eq '"first,second,etc"'
  end
end
