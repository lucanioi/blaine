require 'blaine/station'

describe Blaine::Station do
  subject { described_class.new('S', P(0, 0)) }

  describe '#wait_duration' do
    let(:train) { double(:train) }

    before do
      allow(train).to receive(:express?) { false }
    end

    it 'returns wait duration corresponding to the train\'s length' do
      allow(train).to receive(:length) { 10 }

      expect(subject.wait_duration(train)).to eq 10
    end

    context 'when the train is an express train' do
      it 'returns 0' do
        allow(train).to receive(:length) { 10 }
        allow(train).to receive(:express?) { true }

        expect(subject.wait_duration(train)).to eq 0
      end
    end
  end
end
