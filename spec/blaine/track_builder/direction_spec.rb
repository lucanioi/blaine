require 'blaine/track_builder/direction'

describe Blaine::TrackBuilder::Direction do
  subject { described_class.new(1, 0) }

  describe '#right' do
    it 'returns the next direction to the right' do
      expect(subject.right).to eq described_class.new(1, -1)
    end

    it 'another direction' do
      direction = described_class.new(-1, -1)
      expect(direction.right).to eq described_class.new(-1, 0)
    end
  end

   describe '#left' do
    it 'returns the next direction to the right' do
      expect(subject.left).to eq described_class.new(1, 1)
    end
  end
end
