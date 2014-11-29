require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

def create_sample_data
  let(:sample_data) do
    %w(
      #EXTINF:11,
      2014-08-18-0959250.ts
      #EXTINF:9,
      2014-08-18-0959251.ts
      #EXTINF:12,
      2014-08-18-0959252.ts
      #EXTINF:11,
      2014-08-18-0959253.ts
      #EXTINF:8,
      2014-08-18-0959254.ts
      #EXTINF:10,
      2014-08-18-0959255.ts
      #EXTINF:9,
      2014-08-18-0959256.ts
      #EXTINF:10,
      2014-08-18-0959257.ts)
  end

  let(:sample_pl) do
    pl = M3U8Playlist.new
    sample_data.each do |line|
      if line.index('ts')
        pl << MediaSegment.new(line, pl)
      else
        pl << Tag.new('EXTINF', line.split(':')[1])
      end
    end
    pl
  end

  let(:sample_file) do
    file = M3U8File.new
    file.create_and_add('EXTM3U', nil, nil)
    file.create_and_add('EXT-X-VERSION', nil, '3')
    file.create_and_add('EXT-X-TARGETDURATION', nil, '12')
    file.create_and_add('EXT-X-MEDIA-SEQUENCE', nil, '0')

    sample_data.each do |line|
      if line.index('ts')
        file.add MediaSegment.new(line, file.playlist)
      else
        file.add Tag.new('EXTINF', line.split(':')[1])
      end
    end
    file
  end

  let(:uploaded_ts) do
    %w(2014-08-18-0959250.ts
      2014-08-18-0959251.ts
      2014-08-18-0959252.ts
      2014-08-18-0959253.ts
      2014-08-18-0959254.ts
      2014-08-18-0959255.ts
      2014-08-18-0959256.ts
      2014-08-18-0959257.ts)
  end

  let(:sample_1) do
    {filename: '../m3uzi/spec/samples/valid/2014-08-18-122730.M3U8',
     test_data: [
      [0, '2014-08-18-1227300.ts', 11],
      [3, '2014-08-18-1227303.ts', 10],
      [35, '2014-08-18-12273035.ts', 4],
    ]}
  end

  def validate_against_test_data
    test_data = sample_1[:test_data]
    test_data.each do | dp |
      expect(@m3u8_file.media_segments[dp[0]].path).to eq dp[1]
      expect(@m3u8_file.media_segments[dp[0]].duration).to eq dp[2]
    end
  end
end
