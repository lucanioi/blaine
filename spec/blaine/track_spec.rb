require 'blaine/track'
require 'blaine/track_piece'
require 'blaine/position'

describe Blaine::Track do
  subject { described_class.new(track_pieces) }
  let(:track_pieces) do
    [
      create_track_piece('/',  [0, 0]),
      create_track_piece('-',  [0, 1]),
      create_track_piece('-',  [0, 2]),
      create_track_piece('\\', [0, 3]),
      create_track_piece('|',  [1, 3]),
      create_track_piece('/',  [2, 3]),
      create_track_piece('-',  [2, 2]),
      create_track_piece('-',  [2, 1]),
      create_track_piece('\\', [2, 0]),
      create_track_piece('|',  [1, 0])
    ]
  end

  before do
    create_loop(track_pieces)
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

  describe '#add_train' do
    let(:train) do
      Blaine::Train.new(
        char: 'A',
        length: 3,
        direction: :clockwise,
        express: false
      )
    end
    let(:index) { 0 }

    it 'adds the given train at the nth track piece' do
      subject.add_train(train, at: index)

      expect(subject.track_pieces[index]).to be_attached
      expect(train.attached_track_pieces.first).to be subject.track_pieces[index]
    end

    it 'to_s shows the trains' do
      expected = <<~TRACK.strip
        A--\\
        a  |
        a--/
      TRACK


      subject.add_train(train, at: index)

      expect(subject.to_s).to eq expected
    end
  end

  def create_track_piece(char, position)
    Blaine::TrackPiece.new(char, P(*position))
  end

  def create_loop(track_pieces)
    track_pieces.each_cons(2) do |first, second|
      first.connect(second)
    end

    track_pieces.last.connect(track_pieces.first)
  end
end
