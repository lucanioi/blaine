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

  describe '#attach' do
    it 'returns true if unattached' do
      expect(subject.attach).to be true
    end

    it 'raises a train crash error if already attached' do
      subject.attach

      expect { subject.attach }.to raise_error Blaine::Crash
    end
  end

  describe '#unattach' do
    it 'makes the track piece occupiable again' do
      subject.attach
      subject.unattach

      expect(subject.attach).to be true
    end
  end

  describe '#wait_duration' do
    let(:train) { double(:train) }

    it 'returns zero' do
      expect(subject.wait_duration(train)).to eq 0
    end
  end

  describe '#connected?' do
    context 'when given a track piece that it is connected to' do
      it 'returns true' do
        subject.connect(other_track)

        expect(subject.connected?(other_track)).to be true
        expect(other_track.connected?(subject)).to be true
      end
    end

    context 'when given a track piece that it is not connected to' do
      it 'returns false' do
        expect(subject.connected?(other_track)).to be false
      end
    end

    context 'when given itself' do
      it 'returns false' do
        expect(subject.connected?(subject)).to be false
      end
    end
  end

  describe '#form_crossing' do
    before do
      subject.form_crossing(other_track)
    end

    it 'makes the given track unavailble to attach while itself is attached' do
      subject.attach

      expect { other_track.attach }.to raise_error Blaine::Crash
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
