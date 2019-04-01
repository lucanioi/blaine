require 'matrix'

module Blaine
  class TrackBuilder
    class Grid
      OutOfBounds = Class.new(StandardError)

      class << self
        def build(track_string)
          new(to_matrix(track_string))
        end

        private :new

        def to_matrix(track_string)
          Matrix[*track_string.split("\n").map(&:chars)]
        end
      end

      def initialize(matrix)
        @matrix = matrix
      end

      def get(position)
        matrix[*position.to_a] || raise(OutOfBounds)
      end

      private

      attr_reader :matrix
    end
  end
end
