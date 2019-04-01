module Blaine
  class TrackBuilder
    class Position
      attr_reader :row, :column

      def initialize(row, column)
        @row = row
        @column = column
      end

      def +(other)
        self.class.new(row + other.row, column + other.column)
      end

      def ==(other)
        return false unless other.is_a? self.class
        row == other.row && column == other.column
      end

      def to_a
        [row, column]
      end
    end
  end
end
