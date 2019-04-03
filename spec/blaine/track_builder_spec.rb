require 'blaine/track_builder'
require 'blaine/track'
require 'shared_examples/track_builder_tests'

describe Blaine::TrackBuilder do
  let(:build_error) { described_class::CannotBuildTrack }

  describe '.from_string' do
    context 'when given an empty string' do
      def track_string
        ''
      end

      it 'raises an error' do
        expect { run_method }.to raise_error build_error
      end
    end

    context 'when given a well-formed track string' do
      def track_string
        """\
/--------\\
|        |
\\--------/
        """
      end

      it 'returns a track object' do
        expect(run_method).to be_an_instance_of Blaine::Track
      end
    end

    context 'when given a track string that doesn\'t loop' do
      def track_string
        """\
/--------\\
|
\\--------/
        """
      end

      it 'raises an error' do
        expect { run_method }.to raise_error build_error
      end
    end

    def run_method
      described_class.from_string(track_string)
    end
  end

  describe '.from_string' do
    context 'when given an empty string' do
      def track_string
        ''
      end

      include_examples :validate_length
    end

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
        first_track = run_method.first

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

    context 'complex track' do
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

    def run_method
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
