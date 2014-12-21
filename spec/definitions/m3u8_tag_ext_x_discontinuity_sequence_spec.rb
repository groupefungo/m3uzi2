require_relative '../../lib/m3uzi/specification/m3u8_specification'
require_relative '../../lib/m3uzi/types/tags'
require_relative 'shared_example_positive_number'

include M3Uzi2

describe 'EXT-X-DISCONTINUITY-SEQUENCE' do

  it_should_behave_like "a positive number" do
    let(:spec) { M3Uzi2::HeaderSpecification.new }
    let(:tag) { M3Uzi2::Tag.new('EXT-X-DISCONTINUITY-SEQUENCE',
                                specification: spec) }
  end
end
