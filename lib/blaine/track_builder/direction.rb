require_relative 'position'

module Blaine
  class TrackBuilder
    class Direction < Position
      InvalidDirection = Class.new(StandardError)

      POSITIONS = [
        [-1, 0],
        [-1, 1],
        [0, 1],
        [1, 1],
        [1, 0],
        [1, -1],
        [0, -1],
        [-1, -1]
      ].map(&:freeze).freeze

      def initialize(row, column)
        super
        validate_direction!
      end

      def right
        increment_position(1)
      end

      def left
        increment_position(-1)
      end

      private

      def increment_position(increment)
        self.class.new(*POSITIONS[(enum + increment) % POSITIONS.size])
      end

      def enum
        POSITIONS.index(to_a)
      end

      def validate_direction!
        unless POSITIONS.include?(to_a)
          raise InvalidDirection
        end
      end
    end
  end
end
