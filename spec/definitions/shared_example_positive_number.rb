shared_examples_for 'a positive number' do

  it 'is valid with an integer value' do
    tag.value = 101
    expect(tag.valid?).to be true
  end

  it 'is valid with a string integer value' do
    tag.value = '121'
    expect(tag.valid?).to be true
  end

  it 'is invalid with a negative value' do
    tag.value = -100
    expect(tag.valid?).to be false
  end

  it 'is invalid with a string negative value' do
    tag.value = -100
    expect(tag.valid?).to be false
  end

  it 'is invalid with an float value' do
    tag.value = 121.0
    expect(tag.valid?).to be false
  end

  it 'is invalid with a nil value' do
    tag.value = nil
    expect(tag.valid?).to be false
  end

  it 'is invalid with an empty string value' do
    tag.value = ''
    expect(tag.valid?).to be false
  end
end
