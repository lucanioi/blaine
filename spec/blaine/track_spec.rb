require 'blaine/track'
require 'blaine/track_piece'
require 'blaine/position'

describe Blaine::Track do
  subject { described_class.new(track_pieces) }
  let(:track_pieces) do
    [
      mock_track_piece('/',  [0, 0]),
      mock_track_piece('-',  [0, 1]),
      mock_track_piece('-',  [0, 2]),
      mock_track_piece('\\', [0, 3]),
      mock_track_piece('|',  [1, 3]),
      mock_track_piece('/',  [2, 3]),
      mock_track_piece('-',  [2, 2]),
      mock_track_piece('-',  [2, 1]),
      mock_track_piece('\\', [2, 0]),
      mock_track_piece('|',  [1, 0])
    ]
  end

  describe '#to_s' do
    it 'returns a visualization of the track with strings' do
      expected = <<~TRACK.strip
        /--\\
        |  |
        \\--/
      TRACK

      expect(subject.to_s).to eq expected
    end
  end

  def mock_track_piece(char, position)
    double(:track_piece).tap do |tp|
      allow(tp).to receive(:to_s) { char }
      allow(tp).to receive(:position) { Blaine::Position.new(*position) }
    end
  end
end
