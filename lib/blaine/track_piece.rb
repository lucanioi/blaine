require_relative 'crash'

module Blaine
  class TrackPiece
    CrossingAlreadyFormed = Class.new(StandardError)

    attr_reader :crossing

    def initialize(char)
      @char = char
      @occupied = false
    end

    def next(direction)
      case direction
      when :clockwise then next_track
      when :counterclockwise then previous_track
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

    def occupy
      if free?
        @occupied = true
      else
        raise Crash
      end
    end

    def unoccupy
      @occupied = false
    end

    protected

    attr_accessor :previous_track

    def occupied?
      @occupied
    end

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
      has_crossing? ? !occupied? && !crossing.occupied? : !occupied?
    end
  end
end
