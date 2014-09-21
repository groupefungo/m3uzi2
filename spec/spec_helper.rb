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
end



