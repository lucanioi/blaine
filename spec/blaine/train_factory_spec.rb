require 'blaine/train_factory'
require 'shared_examples/train_tests'

describe Blaine::TrainFactory do
  subject { described_class }
  let(:train) { subject.from_string(string) }

  describe '.from_string' do
    context 'string: A' do
      let(:string) { 'A' }

      include_examples :length, 1
      include_examples :to_s, 'A'
      include_examples :direction, :clockwise
    end

    context 'string: bbbB' do
      let(:string) { 'bbbB' }

      include_examples :length, 4
      include_examples :to_s, 'B'
      include_examples :direction, :clockwise
    end

    context 'string: Bbbbbb' do
      let(:string) { 'Bbbbbb' }

      include_examples :length, 6
      include_examples :to_s, 'B'
      include_examples :direction, :counterclockwise
    end

    context 'string: xxxX' do
      let(:string) { 'xxxX' }

      include_examples :length, 4
      include_examples :to_s, 'X'
      include_examples :direction, :clockwise
      include_examples :express?, true
    end

    context 'invalid train' do
      let(:string) { 'BaaaaB' }

      it 'raises an error' do
        expect { train }.to raise_error described_class::InvalidString
      end
    end
  end
end
