require_relative '../lib/m3uzi/m3u8_file'

include M3Uzi2
describe M3Uzi2::M3U8File do
  let(:file) { M3U8File.new }

  it "will create a header tag" do
    header = file.create_header("EXT-X-VERSION", nil, 1)
    expect(header.class).to eq Tag
  end

  it 'adds a header tag to the headers' do

  end

  it 'adds a playlist tag to the playlist' do

  end



  it 'allows us to add a playlist tag' do

  end
end
