require 'blaine/track_piece'
require 'blaine/position'

describe Blaine::TrackPiece do
  subject { described_class.new('-', position) }
  let(:position) { Blaine::Position.new(0, 0) }
  let(:other_track) { described_class.new('-', position) }

  describe '#next, #connect' do
    it 'is a null track piece by default' do
      expect(subject.next(:clockwise)).to be_nil
      expect(subject.next(:counterclockwise)).to be_nil
    end

    context 'when connected to another track' do
      before do
        subject.connect(other_track)
      end

      it 'returns the next track' do
        expect(subject.next(:clockwise)).to be other_track
      end

      context 'when called with :counterclockwise as direction' do
        it 'returns the previous track' do
          expect(other_track.next(:counterclockwise)).to be subject
        end
      end
    end
  end

  describe '#occupy' do
    it 'returns true if unoccupied' do
      expect(subject.occupy).to be true
    end

    it 'raises a train crash error if already occupied' do
      subject.occupy

      expect { subject.occupy }.to raise_error Blaine::Crash
    end
  end

  describe '#unoccupy' do
    it 'makes the track piece occupiable again' do
      subject.occupy
      subject.unoccupy

      expect(subject.occupy).to be true
    end
  end

  describe '#form_crossing' do
    before do
      subject.form_crossing(other_track)
    end

    it 'makes the given track unavailble to occupy while itself is occupied' do
      subject.occupy

      expect { other_track.occupy }.to raise_error Blaine::Crash
    end

    context 'when there is already a crossing formed' do
      let(:another_track) { described_class.new('-', position) }

      it 'raises an error' do
        invalid_crossing = proc { subject.form_crossing(another_track) }

        expect(&invalid_crossing).to raise_error described_class::CrossingAlreadyFormed
      end
    end
  end
end
