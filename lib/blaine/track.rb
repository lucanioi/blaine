module Blaine
  class Track
    def initialize(track_pieces)
      @track_pieces = track_pieces
    end

    def to_s
      create_matrix.tap do |matrix|
        track_pieces.each do |tp|
          matrix[tp.position.row][tp.position.column] = tp.to_s
        end
      end.map(&:join).join("\n")
    end

    private

    def row_count
      1 + track_pieces.max_by { |tp| tp.position.row }.position.row
    end

    def column_count
      1 + track_pieces.max_by { |tp| tp.position.column }.position.column
    end

    def create_matrix
      Array.new(row_count) { Array.new(column_count) { "\s" } }
    end

    attr_reader :track_pieces
  end
end
