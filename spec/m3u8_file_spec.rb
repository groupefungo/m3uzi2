require_relative 'spec_helper'
require_relative '../lib/m3uzi/m3u8_file'

include M3Uzi2

# This is a very basic set of tests for the various tags
describe M3Uzi2::M3U8File do
  let(:m3u8_file) { M3U8File.new }

  # A set of basic expectations for a valid tag
  def basic_tag_expectations(tag, version)
    expect(tag.class).to eq Tag
    expect(tag.valid?).to eq true
    expect(tag.version).to eq version
  end

  describe :create_and_add do
    it 'creates a tag and adds it to the file via a single call' do
      m3u8_file.create_and_add('EXT-X-VERSION', nil, 2)

      expect(m3u8_file['EXT-X-VERSION'].class).to eq Array
      expect(m3u8_file['EXT-X-VERSION'].size).to eq 1
      expect(m3u8_file['EXT-X-VERSION'][0].class).to eq Tag
    end
  end

  describe :version do
    it 'is a bit complex' do
      expect(true).to be true
    end

    it 'returns the version of the file' do
      m3u8_file.create_and_add('EXT3MU', nil, nil)
      expect(m3u8_file.version).to eq 1
    end

    it 'indicates the version based on the VERSION TAG' do
      m3u8_file.create_and_add('EXT-X-VERSION', nil, 2)
      expect(m3u8_file.version).to eq 2

      m3u8_file['EXT-X-VERSION'][0].value = 4
      expect(m3u8_file.version).to eq 4

      m3u8_file['EXT-X-VERSION'][0].value = 6
      expect(m3u8_file.version).to eq 6
    end

    context 'if the VERSION tag and Tag specification min value dont match' do
      it 'returns the value of EXT-X-VERSION if set' do
        m3u8_file.create_and_add('EXT-X-VERSION', nil, 2)
        expect(m3u8_file.version).to eq 2
        m3u8_file.create_and_add('EXT-X-DISCONTINUITY-SEQUENCE', nil, 10)
        expect(m3u8_file.version).to eq 2
      end

      it 'returns the version of the highest tag if no EXT-X-VERSION tag' do
        m3u8_file.create_and_add('EXT-X-DISCONTINUITY-SEQUENCE', nil, 10)
        expect(m3u8_file.version).to eq 6
      end

      it 'can be forced to return nil on mismatch' do
        m3u8_file.create_and_add('EXT-X-VERSION', nil, 2)
        m3u8_file.create_and_add('EXT-X-DISCONTINUITY-SEQUENCE', nil, 10) # v6
        expect(m3u8_file.version(nil_on_mismatch: true)).to eq nil
      end

      it 'can be forced to return the REAL version acording to the spec' do
        m3u8_file.create_and_add('EXT-X-VERSION', nil, 2)
        m3u8_file.create_and_add('EXT-X-DISCONTINUITY-SEQUENCE', nil, 10) # v6
        expect(m3u8_file.version(return_tag_version: true)).to eq 6
      end
    end
  end

  describe :valid? do
    it 'returns true if the file is valid against the spec' do

    end

    it 'returns false otherwise' do

    end



  end

  describe 'add and <<' do
    it 'adds a valid tag to the file' do
      header = M3U8File.create_tag('EXT-X-VERSION', nil, 2)
      m3u8_file.add(header)

      expect(m3u8_file['EXT-X-VERSION'].class).to eq Array
      expect(m3u8_file['EXT-X-VERSION'].size).to eq 1
      expect(m3u8_file['EXT-X-VERSION'][0].class).to eq Tag
    end
  end

  describe :type do
    it 'allows us to set the type to either UNSPECIFIED, MEDIA or MASTER' do
      expect(m3u8_file.type).to eq :UNSPECIFIED
      m3u8_file.type = :MEDIA
      expect(m3u8_file.type).to eq :MEDIA
      m3u8_file.type = :MASTER
      expect(m3u8_file.type).to eq :MASTER
      m3u8_file.type = :UNSPECIFIED
      expect(m3u8_file.type).to eq :UNSPECIFIED
      m3u8_file.type = :INVALID_VALUE
      expect(m3u8_file.type).to eq :UNSPECIFIED
    end
  end

  describe :[] do
    it 'Returns an array of tags matching tag_name' do

    end
  end

  describe :media_segments do
    it 'Return an array of MediaSegments' do

    end
  end

  describe 'M3U8File#create_tag' do
    it 'returns nil if we attempt to create a tag with an invalid name' do
      tag = M3U8File.create_tag('EXT-X-INVALID', nil, 1)
      expect(tag).to eq nil
    end
  end

  describe :[] do
    it 'Return an array of tags matching tag_name' do

    end
  end

  describe :media_segments do
    it 'Return an array of MediaSegments' do

    end
  end

  describe 'M3U8File#create_tag' do
    it 'returns nil if we attempt to create a tag with an invalid name' do
      tag = M3U8File.create_tag('EXT-X-INVALID', nil, 1)
      expect(tag).to eq nil
    end

    it 'returns nil if we attempt to create a tag with only an empty value' do
      tag = M3U8File.create_tag(nil, nil, '')
      expect(tag).to eq nil
    end

    it 'creates a MediaSegment if we pass a string as the value' do
      tag = M3U8File.create_tag(nil, nil, 'filename.ts')
      expect(tag.class).to eq MediaSegment
    end

    it 'creates a TARGETDURATION tag' do
      tag = M3U8File.create_tag('EXT-X-TARGETDURATION', nil, 10)
      basic_tag_expectations(tag, 1)
    end

    it 'creates a KEY tag' do
      tag = M3U8File.create_tag('EXT-X-KEY',
                                'METHOD=AES-128,'\
                                'URI="https://priv.example.com/key.php?r=52"'\
                                'IV=0x9c7db8778570d05c3177c349fd9236aa',
                                nil)
      basic_tag_expectations(tag, 1)
    end

    it 'creates a PROGRAM-DATE-TIME tag' do
      tag = M3U8File.create_tag('EXT-X-PROGRAM-DATE-TIME',
                                nil,
                                '2010-02-19T14:54:23.031+08:00')
      basic_tag_expectations(tag, 1)
    end

    it 'creates a PROGRAM-DATE-TIME unless the date/time is invalid'  do
      tag = M3U8File.create_tag('EXT-X-PROGRAM-DATE-TIME',
                                nil,
                                '2010-24-19T14:54:23.031')
      expect(tag.valid?).to eq false
    end

    it 'creates an ALLOW-CACHE tag' do
      tag = M3U8File.create_tag('EXT-X-ALLOW-CACHE', nil, 'YES')
      basic_tag_expectations(tag, 1)
      tag.value = 'NO'
      basic_tag_expectations(tag, 1)
      tag.value = 'INVALID-VALUE'
      expect(tag.valid?).to eq false
    end

    it 'creates an ENDLIST tag' do
      tag = M3U8File.create_tag('EXT-X-ENDLIST', nil, nil)
      basic_tag_expectations(tag, 1)
    end

    it 'creates a STREAM-INF tag' do
      tag = M3U8File.create_tag('EXT-X-STREAM-INF', 'BANDWIDTH=7680000', nil)
      basic_tag_expectations(tag, 1)
    end

    it 'creates a DISCONTINUITY tag' do
      tag = M3U8File.create_tag('EXT-X-DISCONTINUITY', nil, nil)
      basic_tag_expectations(tag, 1)
    end

    it 'creates a VERSION tag' do
      tag = M3U8File.create_tag('EXT-X-VERSION', nil, 2)
      basic_tag_expectations(tag, 2)
    end

    it 'creates a PLAYLIST-TYPE tag' do
      tag = M3U8File.create_tag('EXT-X-PLAYLIST-TYPE', nil, 'EVENT')
      basic_tag_expectations(tag, 3)
      tag.value = 'VOD'
      basic_tag_expectations(tag, 3)
      tag.value = 'AN INVALID VALUE'
      expect(tag.valid?).to eq false
    end

    it 'creates a BYTERANGE tag' do
      tag = M3U8File.create_tag('EXT-X-BYTERANGE', nil, '587500@522828')
      basic_tag_expectations(tag, 4)
      tag.value = '587500'
      basic_tag_expectations(tag, 4)
      tag.value = 'INVALID'
      expect(tag.valid?).to eq false
    end

    it 'creates a MEDIA tag' do
      tag = M3U8File.create_tag('EXT-X-MEDIA',
                                'TYPE=AUDIO,GROUP-ID="aac",NAME="English",' \
                                'DEFAULT=YES,AUTOSELECT=YES,LANGUAGE="en",' \
                                'URI="main/english-audio.m3u8"',
                                nil)
      basic_tag_expectations(tag, 4)
    end

    it 'creates an I-FRAMES-ONLY tag' do
      tag = M3U8File.create_tag('EXT-X-I-FRAMES-ONLY', nil, nil)
      basic_tag_expectations(tag, 4)
    end

    it 'creates an I-FRAME-STREAM-INF tag' do
      tag = M3U8File.create_tag('EXT-X-I-FRAME-STREAM-INF',
                                'BANDWIDTH=80000,'\
                                'CODECS="avc1.42e00a,mp4a.40.2",'\
                                'URI="lo/iframes.m3u8"',
                                nil)
      basic_tag_expectations(tag, 4)
    end

    it 'creates a MAP tag' do
      tag = M3U8File.create_tag('EXT-X-MAP',
                                'BYTERANGE="80000",'\
                                'URI="lo/iframes.m3u8"',
                                nil)
      basic_tag_expectations(tag, 5)
    end

    it 'creates a DISCONTINUITY-SEQUENCE tag' do
      tag = M3U8File.create_tag('EXT-X-DISCONTINUITY-SEQUENCE', nil, 10)
      basic_tag_expectations(tag, 6)
    end

    it 'creates an INDEPENDENT-SEGMENTS tag' do
      tag = M3U8File.create_tag('EXT-X-INDEPENDENT-SEGMENTS', nil, nil)
      basic_tag_expectations(tag, 6)
    end

    it 'creates a START tag' do
      tag = M3U8File.create_tag('EXT-X-START',
                                'TIME-OFFSET=10.0,PRECISE=NO', nil)
      basic_tag_expectations(tag, 6)
    end
  end
end
