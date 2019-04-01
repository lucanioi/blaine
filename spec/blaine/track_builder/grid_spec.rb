require 'blaine/track_builder/grid'
require 'blaine/track_builder'

describe Blaine::TrackBuilder::Grid do
  subject { described_class.build(track_string) }

  describe '#get' do
    let(:track_string) do
"""\
/--------\\
|        |
\\--------/
"""
    end

    it 'returns the charater at the given position' do
      actual = subject.get(P(0, 0))

      expect(actual).to eq '/'
    end

    it 'another position' do
      actual = subject.get(P(1, 9))

      expect(actual).to eq '|'
    end

    context 'when the given position is out of bounds' do
      let(:out_of_bounds_error) { described_class::OutOfBounds }

      it 'raises and error' do
        out_of_bounds = proc { subject.get(P(100, 100)) }

        expect(&out_of_bounds).to raise_error out_of_bounds_error
      end
    end
  end

  def P(row, column)
    Blaine::TrackBuilder::Position.new(row, column)
  end
end
