require_relative 'spec_helper'
require_relative '../lib/m3uzi/m3u8_headers'

include M3Uzi2

describe M3U8Headers do
  let(:headers) { M3U8Headers.new }

  describe :specification do
    it 'returns an instance of HeaderSpecification' do
      expect(M3U8Headers.specification.class).to eq M3Uzi2::HeaderSpecification
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

    it 'returns true for EXT-X-DISCONTINUITY-SEQUENCE' do
      expect(M3U8Headers.valid_header?('EXT-X-DISCONTINUITY-SEQUENCE')).to eq true
    end

    it 'returns true for EXT-X-MEDIA-SEQUENCE' do
      expect(M3U8Headers.valid_header?('EXT-X-MEDIA-SEQUENCE')).to eq true
    end

    it 'returns false for anything else' do
      expect(M3U8Headers.valid_header?('EXTINF')).to eq false
      expect(M3U8Headers.valid_header?('EXTINVALID')).to eq false
    end
  end

  describe :<< do
    it 'only adds the header once' do
      expect(headers['EXT-X-MEDIA-SEQUENCE'].size).to eq 0
      headers << Tag.new('EXT-X-MEDIA-SEQUENCE', '0')
      expect(headers['EXT-X-MEDIA-SEQUENCE'].size).to eq 1
      headers << Tag.new('EXT-X-MEDIA-SEQUENCE', '0')
      expect(headers['EXT-X-MEDIA-SEQUENCE'].size).to eq 1
    end
  end

  describe :increment_media_sequence do
    it 'increments the value of the media sequence' do
      headers << Tag.new('EXT-X-MEDIA-SEQUENCE', '0')
      headers.increment_media_sequence
      expect(headers['EXT-X-MEDIA-SEQUENCE'][0].value).to eq '1'
      headers.increment_media_sequence
      expect(headers['EXT-X-MEDIA-SEQUENCE'][0].value).to eq '2'
    end

    it 'returns the new value' do
      expect(headers.increment_media_sequence).to eq '1'
    end

    it 'adds the media sequence tag if it isnt present' do
      expect(headers['EXT-X-MEDIA-SEQUENCE'].size).to eq 0
      headers.increment_media_sequence
      expect(headers['EXT-X-MEDIA-SEQUENCE'].size).to eq 1
    end
  end

  describe :media_sequence do
    it 'returns 0 if not incremented previously' do
      expect(headers.media_sequence).to eq "0"
    end

    it 'returns the value incremented previously' do
      headers.increment_media_sequence
      headers.increment_media_sequence
      expect(headers.media_sequence).to eq "2"
    end
  end
end
