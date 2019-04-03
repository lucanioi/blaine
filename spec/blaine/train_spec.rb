require 'blaine/train'
require 'blaine/track_piece'

describe Blaine::Train do
  subject do
    described_class.new(
      char: char,
      length: length,
      direction: direction,
      express: express
    )
  end
  let(:char) { 'A' }
  let(:length) { 3 }
  let(:direction) { :clockwise }
  let(:express) { false }

  describe '#attach_to_track_piece' do
    it 'occupies the given track piece' do
      track_piece = create_looped_track_pieces(5).first
      subject.attach_to_track_piece(track_piece)

      expect(track_piece).to be_attached
    end

    it 'occupies preceding track pieces corresponding to its length' do
      track_pieces = create_looped_track_pieces(5)

      subject.attach_to_track_piece(track_pieces.first)

      expect(track_pieces[0]).to be_attached
      expect(track_pieces[-1]).to be_attached
      expect(track_pieces[-2]).to be_attached
    end

    context 'when the direction is counterclockwise' do
      let(:direction) { :counterclockwise }

      it 'occupies the tracks in the opposite direction' do
      track_pieces = create_looped_track_pieces(5)

      subject.attach_to_track_piece(track_pieces.first)

      expect(track_pieces[0]).to be_attached
      expect(track_pieces[1]).to be_attached
      expect(track_pieces[2]).to be_attached
      end
    end
  end

  describe '#move_forward' do
    context 'when the direction is clockwise' do
      it 'occupies the set of track pieces one unit ahead' do
        track_pieces = create_looped_track_pieces(5)
        subject.attach_to_track_piece(track_pieces.first)

        subject.move_forward

        expect(track_pieces[1]).to be_attached
        expect(track_pieces[0]).to be_attached
        expect(track_pieces[-1]).to be_attached
        expect(track_pieces[-2]).to_not be_attached
      end
    end

    context 'when the direction is counterclockwise' do
      let(:direction) { :counterclockwise }

      it 'moves the other way' do
        track_pieces = create_looped_track_pieces(5)
        subject.attach_to_track_piece(track_pieces.first)

        subject.move_forward

        expect(track_pieces[-1]).to be_attached
        expect(track_pieces[0]).to be_attached
        expect(track_pieces[1]).to be_attached
        expect(track_pieces[2]).to_not be_attached
      end
    end

    context 'when the train is attached to a station' do
      it 'does\'nt move the first time' do
        track_pieces = create_looped_track_pieces_with_station(5)
        subject.attach_to_track_piece(track_pieces.first)

        subject.move_forward

        expect(track_pieces[1]).to_not be_attached
        expect(track_pieces[0]).to be_attached
        expect(track_pieces[-1]).to be_attached
        expect(track_pieces[-2]).to be_attached
        expect(track_pieces[-3]).to_not be_attached
      end

      it 'moves after as many times as the length of the train' do
        track_pieces = create_looped_track_pieces_with_station(5)
        subject.attach_to_track_piece(track_pieces.first)

        subject.move_forward
        subject.move_forward
        subject.move_forward

        subject.move_forward

        expect(track_pieces[1]).to be_attached
        expect(track_pieces[0]).to be_attached
        expect(track_pieces[-1]).to be_attached
        expect(track_pieces[-2]).to_not be_attached
      end

      context 'given an express train' do
        let(:express) { true }

        it 'doesn\'t wait at the station' do
          track_pieces = create_looped_track_pieces_with_station(5)
          subject.attach_to_track_piece(track_pieces.first)

          subject.move_forward

          expect(track_pieces[1]).to be_attached
          expect(track_pieces[0]).to be_attached
          expect(track_pieces[-1]).to be_attached
          expect(track_pieces[-2]).to_not be_attached
        end
      end
    end
  end

  def create_looped_track_pieces(size)
    Array.new(size) { create_track_piece }.tap do |track_pieces|
      track_pieces.each_cons(2) do |t1, t2|
        t1.connect(t2)
      end

      track_pieces.last.connect(track_pieces.first)
    end
  end

  def create_looped_track_pieces_with_station(size)
    create_looped_track_pieces(size).tap do |track_pieces|
      station = create_station
      track_pieces.last.connect(station)
      station.connect(track_pieces.first)
      track_pieces.prepend(station)
    end
  end

  def create_track_piece
    position = double(:position)
    Blaine::TrackPiece.new('-', position)
  end

  def create_station
    position = double(:position)
    Blaine::Station.new('S', position)
  end
end
