require_relative 'spec_helper'
require_relative '../lib/m3uzi/specification/m3u8_specification'
require_relative '../lib/m3uzi/types/media_segment'
require_relative '../lib/m3uzi/types/tags'

include M3Uzi2

#   EXTINF                  - applies only to this media segment
#   EXT-X-BYTERANGE         - applies only to this media segment
#   EXT-X-PROGRAM-DATE-TIME - applies only to this media segment
#
#   EXT-X-DISCONTINUITY     - applies only to this media segment
#                             .... sortof
#
#   EXT-X-KEY - applies to this and all subsequent media segments
#   EXT-X-MAP - applies to this and all subsequent media segments

describe MediaSegment do
  let(:plspec) { MediaPlaylistSpecification.new }
  let(:path) { 'file.ts' }
  let(:segment) { MediaSegment.new(path) }

  describe :initialize do
    it 'creates a new media segment'  do
      expect(MediaSegment.new(segment)).not_to eq nil
    end
  end

  describe :path do
  end

  describe :playlist do
  end

  describe :value do
  end

  describe :version do
  end

  describe :playlist_compatability do
  end

  describe :to_s do
  end

  describe :valid? do
  end

  describe :add_segment_tag do
    let(:tag) { Tag.new('EXTINF', 10.0) }
    let(:same_name_tag) { Tag.new('EXTINF', 11.0) }
    before(:each) { segment.add_segment_tag(tag) }

    it 'allows us to add a tag to the media segment' do
      expect(segment.segment_tag('EXTINF')).to eq tag
    end

    it 'fails if the tag is present' do
      expect { segment.add_segment_tag(tag) }.to raise_error(RuntimeError)
    end

    it 'fails if a tag with the same name is present' do
      expect { segment.add_segment_tag(same_name_tag) }.to raise_error(RuntimeError)
    end
  end

  describe :clear_segment_tag do
    let(:tag) { Tag.new('EXTINF', 10.0) }
    before(:each) { segment.add_segment_tag(tag) }

    it 'deletes all tags' do
      expect( segment.segment_tags ).not_to eq []
      segment.clear_segment_tags
      expect( segment.segment_tags ).to eq []
    end
  end

  describe :remove_segment_tag do
    let(:tag) { Tag.new('EXTINF', 10.0) }
    let(:d_tag) { Tag.new('EXT-X-DISCONTINUITY') }
    before(:each) do
      segment.add_segment_tag(tag)
      segment.add_segment_tag(d_tag)
    end

    it 'removes a specific tag from the list by tag' do
      segment.remove_segment_tag(d_tag)
      expect(segment.segment_tag('EXTINF')).to eq tag
      expect(segment.segment_tag(d_tag)).to eq nil
    end

    it 'removes a specific tag from the list by name' do
      segment.remove_segment_tag(d_tag.name)
      expect(segment.segment_tag('EXTINF')).to eq tag
      expect(segment.segment_tag(d_tag)).to eq nil
    end
  end

  describe :has_tag? do
    let(:tag) { Tag.new('EXTINF', 10.0) }
    let(:d_tag) { Tag.new('EXT-X-DISCONTINUITY') }
    before(:each) do
      segment.add_segment_tag(tag)
    end

    it 'returns true if a tag is present' do
      expect(segment.has_tag?(tag)).to eq true
    end

    it 'returns true if a tag name is present' do
      expect(segment.has_tag?(tag.name)).to eq true
    end

    it 'returns false if a tag is not present' do
      expect(segment.has_tag?(d_tag)).to eq false
    end

    it 'returns false if a tag name is not present' do
      expect(segment.has_tag?(d_tag.name)).to eq false
    end
  end

  describe :applicable_tags do
    create_sample_data

    it 'returns all tags which apply to a given media segment' do
      filename = '../m3uzi/spec/samples/valid/applicable_tags.M3U8'
      @m3u8_file   = M3U8File.new(filename)
      @m3u8_reader = M3U8Reader.new(@m3u8_file)
      @m3u8_reader.read

      expect(@m3u8_file.media_segments[1].applicable_tags.count).to eq 1
      expect(@m3u8_file.media_segments[6].applicable_tags.count).to eq 2
      expect(@m3u8_file.media_segments[8].applicable_tags.count).to eq 3
    end

  end

  describe :duration do
  end
end
