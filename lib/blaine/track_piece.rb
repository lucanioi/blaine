require_relative 'crash'

module Blaine
  class TrackPiece
    CrossingAlreadyFormed = Class.new(StandardError)

    WAIT_DURATION = 0

    attr_reader :crossing, :position

    def initialize(char, position)
      @char = char
      @position = position
      @attached = false
    end

    def next(direction)
      case direction
      when :clockwise then next_track
      when :counterclockwise then previous_track
      end
    end

    def previous(direction)
      case direction
      when :clockwise then previous_track
      when :counterclockwise then next_track
      end
    end

    def to_s
      char
    end

    def connect(other)
      self.next_track = other
      other.previous_track = self
    end

    def form_crossing(other)
      self.crossing = other
      other.crossing = self
    end

    def wait_duration(_train)
      WAIT_DURATION
    end

    def connected?(other)
      next_track == other || previous_track == other
    end

    def attach
      if free?
        @attached = true
      else
        raise Crash
      end
    end

    def unattach
      @attached = false
    end

    def attached?
      @attached
    end

    protected

    attr_accessor :previous_track

    def crossing=(other)
      if has_crossing?
        raise CrossingAlreadyFormed
      end

      @crossing = other
    end

    def has_crossing?
      !!crossing
    end

    private

    attr_accessor :next_track
    attr_reader :char

    def free?
      has_crossing? ? !attached? && !crossing.attached? : !attached?
    end
  end
end
