require_relative 'track_piece'

module Blaine
  class TrackBuilder
    class << self
      def to_track_pieces(track_string)
        new(track_string).to_track_pieces
      end

      private :new
    end

    def initialize(string)
      @string = string
      # @grid = Grid.new(string)
    end

    def to_track_pieces
      Array.new(string.length) { TrackPiece.new }.tap do |track_pieces|
        track_pieces.each_cons(2) do |track, other_track|
          track.connect(other_track)
        end
      end
    end

    private

    attr_reader :string
  end
end
