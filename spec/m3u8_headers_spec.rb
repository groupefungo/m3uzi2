require_relative 'spec_helper'
require_relative '../lib/m3uzi/m3u8_headers'

describe M3U8Headers do

  describe :specification do
    it 'returns an instance of HeaderSpecification' do
    end
  end

  describe :valid_header do
    it 'returns true for EXT3MU' do
      expect(M3U8Headers.valid_header?('EXTM3U')).to eq true
    end

    it 'returns true for EXT-X-VERSION' do
      expect(M3U8Headers.valid_header?('EXT-X-VERSION')).to eq true
    end

    it 'returns true for EXT-X-TARGETDURATION' do
      expect(M3U8Headers.valid_header?('EXT-X-TARGETDURATION')).to eq true
    end

    it 'returns true for EXT-X-PLAYLIST-TYPE' do
      expect(M3U8Headers.valid_header?('EXT-X-PLAYLIST-TYPE')).to eq true
    end

    it 'returns true for EXT-X-ALLOW-CACHE' do
      expect(M3U8Headers.valid_header?('EXT-X-ALLOW-CACHE')).to eq true
    end

    it 'returns true for EXT-X-START' do
      expect(M3U8Headers.valid_header?('EXT-X-START')).to eq true
    end

    it 'returns true for EXT-X-MEDIA-SEQUENCE' do
      expect(M3U8Headers.valid_header?('EXT-X-MEDIA-SEQUENCE')).to eq true
    end

    it 'returns false for anything else' do
      expect(M3U8Headers.valid_header?('EXTINF')).to eq false
      expect(M3U8Headers.valid_header?('EXTINVALID')).to eq false
    end
  end

  describe :increment_media_sequence do
    it 'increments the value of the media sequence if present' do
      headers = M3U8Headers.new
      headers << Tag.new('EXT3MU')
      headers << Tag.new('EXT-X-MEDIA-SEQUENCE', '0')
      headers.increment_media_sequence
      expect(headers['EXT-X-MEDIA-SEQUENCE'][0].value).to eq '1'
    end

    it 'returns nil if the tag isnt present' do
      headers = M3U8Headers.new
      expect(headers.increment_media_sequence).to eq nil
    end
  end
end
