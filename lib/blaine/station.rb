require_relative 'track_piece'

module Blaine
  class Station < TrackPiece
    def wait_duration(train)
      return 0 if train.express?
      train.length
    end
  end
end
