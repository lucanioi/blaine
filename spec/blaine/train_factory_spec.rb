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

    context 'string: Bbbb' do
      let(:string) { 'Bbbb' }

      include_examples :length, 4
      include_examples :to_s, 'B'
      include_examples :direction, :clockwise
    end

    context 'string: bbbbbB' do
      let(:string) { 'bbbbbB' }

      include_examples :length, 6
      include_examples :to_s, 'B'
      include_examples :direction, :counterclockwise
    end

    context 'string: Xxxx' do
      let(:string) { 'Xxxx' }

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
