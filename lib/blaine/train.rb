module Blaine
  class Train
    attr_reader :length, :direction, :attached_track_pieces

    def initialize(char:, length:, direction:, express: false)
      @char = char
      @length = length
      @direction = direction
      @express = express
      @attached_track_pieces = []
    end

    def attach_to_track_piece(track_piece, carriages_left = length)
      register_wait_duration(track_piece) if carriages_left == length
      return if carriages_left <= 0
      track_piece.attach
      @attached_track_pieces << track_piece

      attach_to_track_piece(track_piece.previous(direction), carriages_left - 1)
    end

    def move_forward
      return false if wait?
      next_track_piece.tap do |next_tp|
        release_tracks
        attach_to_track_piece(next_tp)
      end
      moved
    ensure
      decrement_wait_duration
    end

    def express?
      @express
    end

    def to_s
      @char
    end

    private

    def next_track_piece
      track_piece_at_engine.next(direction)
    end

    def register_wait_duration(track_piece)
      @wait_duration = track_piece.wait_duration(self)
    end

    def wait?
      return false unless moved?
      wait_duration > 0
    end

    def decrement_wait_duration
      @wait_duration -= 1 if wait_duration > 0
    end

    def wait_duration
      @wait_duration ||= 0
    end

    def release_tracks
      attached_track_pieces.map(&:unattach)
      attached_track_pieces.clear
    end

    def track_piece_at_engine
      attached_track_pieces.first
    end

    def moved?
      !!@moved
    end

    def moved
      @moved = true
    end
  end
end
