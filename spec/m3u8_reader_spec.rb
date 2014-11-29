require_relative 'spec_helper'
require_relative '../lib/m3uzi/m3u8_reader'
require_relative '../lib/m3uzi/m3u8_file'

include M3Uzi2

describe M3U8Reader do
  create_sample_data

  before(:each) do
    @m3u8_file   = M3U8File.new(sample_1[:filename])
    @m3u8_reader = M3U8Reader.new(@m3u8_file)
  end

  describe :initialize do

  end

  describe :read_method do
  end

  describe :read_file do
  end

  describe :read_io_stream do
    it 'loads an m3u8 file into an M3U8File structure' do
      stream = StringIO.new(File.open( sample_1[:filename], "rb").read)
      @m3u8_reader.read(stream)
      validate_against_test_data
    end
  end

  describe :read do
    it 'loads an m3u8 file into an M3U8File structure' do
      @m3u8_reader.read
      validate_against_test_data
    end
  end
end
