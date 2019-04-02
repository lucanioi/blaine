require_relative 'track_piece'
require_relative 'track_builder/grid'
require_relative 'track_builder/position'

module Blaine
  class TrackBuilder
    TRACK_CHARS = %w[/ \\ - | + X S].freeze
    CROSSING_CHARS = %w[+ X]

    class << self
      def to_track_pieces(track_string)
        new(track_string).to_track_pieces
      end

      private :new
    end

    def initialize(string)
      @string = string
      @grid = Grid.build(string)
      @previous_position = nil
      @direction = Direction.new(0, 1)
      @track_pieces = []
    end

    def to_track_pieces
      return track_pieces if string.empty?

      until finished?
        # puts("char: #{current_char} --- pos: #{current_position.to_a} dir: #{direction.to_a}")
        @track_pieces << create_track_piece
        move_forward!
      end

      connected_track_pieces
    end

    private

    attr_reader *[
      :string,
      :grid,
      :starting_position,
      :current_position,
      :previous_position,
      :direction,
      :track_pieces
    ]

    def move_forward!
      @direction = find_next_direction
      @previous_position = current_position
      @current_position = current_position + direction
    end

    def create_track_piece
      TrackPiece.new(current_char).tap do |track_piece|
        form_crossing_if_needed(track_piece)
      end
    end

    def possible_next_directions
      case [previous_char, current_char]
      when ['', '/'], ['-', '-'], ['\\', '|'], ['\\', '-'], ['/', '-'], ['/', '|'], ['|', '|'], ['-', '+'], ['+', '-'], ['|', '+'], ['+', '|']
        [direction.dup]
      when ['-', '\\'], ['|', '/']
        [direction.right, direction.right.right]
      when ['-', '/'], ['|', '\\']
        [direction.left, direction.left.left]
      else
        []
      end
    end

    def find_next_direction
      next_direction = possible_next_directions.find do |direction|
        track_char? get_char(current_position + direction)
      end

      next_direction || dead_end! && direction
    end

    def form_crossing_if_needed(track_piece)
      return unless crossing_char?(current_char)

      if other_piece = crossings[current_position.to_a]
        track_piece.form_crossing(other_piece)
      else
        crossings[current_position.to_a] = track_piece
      end
    end

    def connected_track_pieces
      track_pieces.tap do |pieces|
        pieces.each_cons(2) do |piece, next_piece|
          piece.connect(next_piece)
        end

        make_loop if starting_position == current_position
      end
    end

    def track_char?(char)
      TRACK_CHARS.include?(char)
    end

    def crossing_char?(char)
      CROSSING_CHARS.include?(char)
    end

    def current_char
      get_char(current_position)
    end

    def previous_char
      previous_position ? get_char(previous_position) : ''
    end

    def current_position
      @current_position ||= starting_position.dup
    end

    def starting_position
      @starting_position ||= find_starting_position
    end

    def find_starting_position
      Position.new(*grid.first_element_position)
    end

    def make_loop
      track_pieces.last.connect(track_pieces.first)
    end

    def get_char(position)
      grid.get(position)
    end

    def crossings
      @crossings ||= {}
    end

    def finished?
      track_pieces.any? &&
        (starting_position == current_position || dead_end?)
    end

    def dead_end?
      !!@dead_end
    end

    def dead_end!
      @dead_end = true
    end
  end
end
