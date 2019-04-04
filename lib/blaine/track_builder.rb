require_relative 'track_piece'
require_relative 'track'
require_relative 'station'
require_relative 'position'
require_relative 'track_builder/grid'
require_relative 'track_builder/direction'

module Blaine
  class TrackBuilder
    CannotBuildTrack = Class.new(StandardError)

    TRACK_CHARS = %w[/ \\ - | + X S].freeze
    CROSSING_CHARS = %w[+ X S].freeze
    DIAGONAL_CHARS = %w[/ \\].freeze
    STATION_CHARS = %w[S].freeze

    DIRECTIONAL_CHANGES = {
      straight: [
        ['', '/'],
        ['-', '-'],
        ['|', '|'],
        ['+', '+'],
        ['X', 'X'],
        ['\\', '|'],
        ['\\', '-'],
        ['/', '-'],
        ['/', '|'],
        ['-', '+'],
        ['+', '-'],
        ['|', '+'],
        ['+', '|'],
        ['X', '\\'],
        ['\\', 'X'],
        ['X', '/'],
        ['/', 'X'],
        ['S', '-'],
        ['-', 'S'],
        ['S', '|'],
        ['|', 'S'],
        ['S', '\\'],
        ['\\', 'S'],
        ['S', '/'],
        ['/', 'S'],
      ],
      straight_or_half_turn: [
        ['/', '/'], ['\\', '\\']
      ],
      right: [
        ['-', '\\'],
        ['|', '/']
      ],
      half_right: [
        ['+', '/']
      ],
      half_left: [
        ['+', '\\']
      ],
      left: [
        ['-', '/'],
        ['|', '\\']
      ]
    }

    class << self
      def from_string(track_string)
        track_pieces = to_track_pieces(track_string)
        raise CannotBuildTrack if track_pieces.empty?
        raise CannotBuildTrack unless loops?(track_pieces)

        Track.new(track_pieces)
      end

      def to_track_pieces(track_string)
        new(track_string).to_track_pieces
      end

      private :new

      def loops?(track_pieces)
        track_pieces.first.connected?(track_pieces.last)
      end
    end

    def initialize(string)
      @string = string
      @grid = Grid.build(string)
      @previous_position = nil
      @current_direction = Direction.new(0, 1)
      @track_pieces = []
    end

    def to_track_pieces
      return track_pieces if string.empty?

      until finished?
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
      :current_direction,
      :track_pieces
    ]

    def move_forward!
      @current_direction = find_next_direction
      @previous_position = current_position
      @current_position = current_position + current_direction
    end

    def create_track_piece
      create_track_piece_from_current_char.tap do |track_piece|
        form_crossing_if_needed(track_piece)
      end
    end

    def possible_next_directions
      case [previous_char, current_char]
      when *DIRECTIONAL_CHANGES[:straight]
        [current_direction.dup]
      when *DIRECTIONAL_CHANGES[:straight_or_half_turn]
        [current_direction.dup, current_direction.left, current_direction.right]
      when *DIRECTIONAL_CHANGES[:right]
        [current_direction.right, current_direction.right.right]
      when *DIRECTIONAL_CHANGES[:half_right]
        [current_direction.right]
      when *DIRECTIONAL_CHANGES[:left]
        [current_direction.left, current_direction.left.left]
      when *DIRECTIONAL_CHANGES[:half_left]
        [current_direction.left]
      else
        raise CannotBuildTrack
      end
    end

    def find_next_direction
      next_direction = possible_next_directions.find do |direction|
        track_char? get_char(current_position + direction)
      end

      next_direction || dead_end! && current_direction
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

        loop_tracks if starting_position == current_position
      end
    end

    def create_track_piece_from_current_char
      case current_char
      when *STATION_CHARS
        Station.new(current_char, current_position)
      when *TRACK_CHARS
        TrackPiece.new(current_char, current_position)
      else
        raise CannotBuildTrack
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

    def loop_tracks
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
