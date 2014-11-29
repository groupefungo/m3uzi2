require_relative 'spec_helper'
require_relative '../lib/m3uzi/m3u8_playlist'

describe M3U8Playlist do
  create_sample_data

  it 'is a kindof M3U8TagList' do
    expect(sample_pl).to be_kind_of M3U8TagList
  end

  it 'has a specification' do
    expect(M3U8Playlist.specification).to be_kind_of MediaPlaylistSpecification
  end

  it 'returns true or false if a tag name is valid' do
    expect(M3U8Playlist.valid_tag?('EXTINF')).to be true
    expect(M3U8Playlist.valid_tag?('EXTIVALIDTAG')).to be false
  end

  it 'creates a media segment' do
    expect(M3U8Playlist.create_media_segment('2013-08-091212.ts')).to \
      be_kind_of MediaSegment
  end

  it 'returns true if the playlist has an EXT-X-ENDLIST tag' do
    expect(sample_pl.final_media_segment?).to be false
    sample_pl << Tag.new('EXT-X-ENDLIST')
    expect(sample_pl.final_media_segment?).to be true
  end

  it 'provides a Convenience method to return the total duration of all '\
     'media segments' do
    expect(sample_pl.total_duration).to eq 80
  end

  it 'returns all the media_segments in the playlist' do
    expect(sample_pl.media_segments.size).to eq 8
  end

  describe :delete_media_segment do
    it 'deletes a media segment by filename' do
      sample_pl.delete_media_segment('2014-08-18-0959257.ts')
      expect(sample_pl.media_segments[sample_pl.media_segments.size - 1].path).to \
        eq '2014-08-18-0959256.ts'
    end

    it 'deletes tags which applied to the segment' do
      sample_pl.delete_media_segment('2014-08-18-0959257.ts')
      expect(sample_pl['EXTINF'][sample_pl['EXTINF'].size - 1].value).to \
        eq '9,'
    end

    it 'returns false if the segment wasnt found' do
      expect(sample_pl.delete_media_segment('xxx-08-18-0959257.ts')).to \
        eq false
    end
  end
end
