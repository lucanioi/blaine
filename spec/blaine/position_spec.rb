require 'blaine/position'

describe Blaine::Position do
  subject { described_class.new(3, 5) }
  let(:other_position) { described_class.new(-1, 9) }

  describe '#+' do
    it 'returns the sum of two positions' do
      new_position = subject + other_position

      expect(new_position).to eq described_class.new(2, 14)
    end
  end
end
