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
          Matrix[*normalize_rows(track_string)]
        end

        def normalize_rows(track_string)
          return [[]] if track_string.empty?

          track_string.split("\n").map(&:chars).tap do |rows|
            max_row_size = rows.max_by(&:size).size

            rows.each do |row|
              row << '' until row.size == max_row_size
            end
          end
        end
      end

      def initialize(matrix)
        @matrix = matrix
      end

      def get(position)
        return '' if position.row < 0 || position.column < 0
        matrix[*position.to_a] || ''
      end

      def first_element_position
        matrix.each_with_index do |e, row, col|
          return [row, col] if !e.strip.empty?
        end
      end

      private

      attr_reader :matrix
    end
  end
end
