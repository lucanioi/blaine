require 'blaine/track_builder'

shared_examples :validate_connected do
  it 'track pieces connect' do
    run_method.each_cons(2) do |track, other_track|
      expect(track.next(:clockwise)).to be other_track
    end
  end
end

shared_examples :validate_length do |length|
  it 'returns an array of track pieces with the correct length' do
    expect(run_method.size).to eq length
  end
end

describe Blaine::TrackBuilder do
  describe '.from_string' do
    context 'when given an empty string' do
      def track_string
        ''
      end

      include_examples :validate_length, 0
    end

    context 'when given a straight line' do
      def track_string
        '----------'
      end

      include_examples :validate_length, 10
      include_examples :validate_connected
    end

    xcontext 'when given a corner' do
      def track_string
        '---------\\' \
        '         |'
      end

      include_examples :validate_length, 11
      include_examples :validate_connected
    end

    def run_method
      described_class.to_track_pieces(track_string)
    end
  end
end
