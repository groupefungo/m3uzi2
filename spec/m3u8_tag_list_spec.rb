require_relative 'spec_helper'
require_relative '../lib/m3uzi/m3u8_tag_list'
require_relative '../lib/m3uzi/m3u8_headers'

describe M3U8TagList do

  describe :has_tag_name? do
    let(:headers) { M3U8Headers.new }
    it 'returns true if a tag is present' do
      headers << Tag.new('EXT-X-MEDIA-SEQUENCE', '0')
      expect(headers.has_tag_name?('EXT-X-MEDIA-SEQUENCE')).to eq true
    end

    it 'returns false if a tag is not present' do
      expect(headers.has_tag_name?('EXT-X-MEDIA-SEQUENCE')).to eq false
    end
  end

end


