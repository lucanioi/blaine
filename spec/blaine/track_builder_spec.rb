require 'blaine/track_builder'

shared_examples :validate_connected do
  it 'track pieces connect' do
    run_from_string.each_cons(2) do |track, other_track|
      expect(track.next(:clockwise)).to be other_track
    end
  end
end

shared_examples :validate_loop do
  include_examples :validate_connected

  it 'track pieces loop' do
    track_pieces = run_from_string
    expect(track_pieces.last.next(:clockwise)).to be track_pieces.first
  end
end

shared_examples :validate_length do |length|
  it 'correct number of track pieces' do
    expected = length || number_of_track_chars + number_of_crossing_chars
    expect(run_from_string.size).to eq expected
  end
end

shared_examples :validate_crossings do |*chars|
  it 'forms a crossing correctly' do
    first, second = run_from_string.select { |piece| chars.include? piece.to_s }

    expect(first.crossing).to be second
  end
end

shared_examples :validate_stations do |stations_count|
  it 'creates stations' do
    stations = run_from_string.select { |tp| tp.is_a? Blaine::Station }
    expected = stations_count || track_string.count('S')

    expect(stations.size).to eq expected
  end
end

describe Blaine::TrackBuilder do
  describe '.from_string' do
    context 'when given an empty string' do
      def track_string
        ''
      end

      include_examples :validate_length    end

    context 'when given a straight line' do
      def track_string
        '/---------'
      end

      include_examples :validate_length
      include_examples :validate_connected
    end

    context 'when given a corner' do
      def track_string
        """\
/--------\\
         |

        """
      end

      include_examples :validate_length
      include_examples :validate_connected
    end

    context 'when given a square loop' do
      def track_string
        """\
/--------\\
|        |
\\--------/
        """
      end

      include_examples :validate_length
      include_examples :validate_loop
    end

    context 'when a track that doesn\'t start in the top left corner' do
      def track_string
        """\
      /----\\
      |    |
/-----/    |
|          |
\\----------/
        """
      end

      it 'starts at the correct point' do
        first_track = run_from_string.first

        expect(first_track.to_s).to eq '/'
      end

      include_examples :validate_length
      include_examples :validate_loop
    end

    context 'when a track contains a crossing' do
      def track_string
        """\
      /----\\
      |    |
/-----+----/
|     |
\\-----/
        """
      end

      include_examples :validate_length
      include_examples :validate_loop
      include_examples :validate_crossings, '+'
    end

    context 'diagonal crossing' do
      def track_string
        """\
/---\\   /---\\
|    \\ /    |
|     X     |
|    / \\    |
\\---/   \\---/
        """
      end

      include_examples :validate_length
      include_examples :validate_loop
      include_examples :validate_crossings, 'X'
    end

    # out of scope for this kata
    xcontext 'ambiguous corners' do
      def track_string
        """\
  /--------------------\\
  |  /--------\\/----\\  |
  \\-/         ||    |  |
/-------------++----/  |
|             ||       |
\\-------------/\\-------/
        """
      end

      include_examples :validate_length
      include_examples :validate_loop
      include_examples :validate_crossings, '+'
    end

    context 'track with stations' do
      def track_string
        """\
      /----\\
      |    |
/-----/    S
|          |
\\---S--\\ /-/
       | |
       | \\-\\
       |    \\-----\\
       \\          |
        \\         /
         S       /
          \\     S
           \\   /
            \\-/
        """
      end

      include_examples :validate_length
      include_examples :validate_loop
      include_examples :validate_stations
    end

    context 'crossing stations' do
      def track_string
        """\
/---\\   /---\\
|    \\ /    |
|     S     |
|    / \\    |
|   /   \\---/
|   |
|   \\------\\
|          |
\\-----\\    |
      |    |
/-----S----/
|     |
\\-----/
        """
      end

      include_examples :validate_length, 74
      include_examples :validate_loop
      include_examples :validate_stations, 4
      include_examples :validate_crossings, 'S'
    end

    xcontext 'complex track' do
      def track_string
"""\
                                /------------\\
/-------------\\                /             |
|             |               /              S
|             |              /               |
|        /----+--------------+------\\        |
\\       /     |              |      |        |
 \\      |     \\              |      |        |
 |      |      \\-------------+------+--------+---\\
 |      |                    |      |        |   |
 \\------+--------------------+------/        /   |
        |                    |              /    |
        \\------S-------------+-------------/     |
                             |                   |
/-------------\\              |                   |
|             |              |             /-----+----\\
|             |              |             |     |     \\
\\-------------+--------------+-----S-------+-----/      \\
              |              |             |             \\
              |              |             |             |
              |              \\-------------+-------------/
              |                            |
              \\----------------------------/
"""
      end

      include_examples :validate_length
      include_examples :validate_loop
      include_examples :validate_stations
      include_examples :validate_crossings, '+'
    end

    def run_from_string
      described_class.to_track_pieces(track_string)
    end

    def number_of_track_chars
      all_track_chars.size
    end

    def number_of_crossing_chars
      all_track_chars.select { |char| ['+', 'X'].include?(char) }.size
    end

    def all_track_chars
      track_string.chars.map(&:strip).reject(&:empty?)
    end
  end
end
