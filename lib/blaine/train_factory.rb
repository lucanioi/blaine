require 'blaine/train'

module Blaine
  module TrainFactory
    InvalidString = Class.new(StandardError)

    EXPRESS_TRAIN = 'X'.freeze

    VALID_STRING = /(?:\A[A-Z][a-z]*\z)|(?:\A[a-z]+[A-Z]\z)/

    module_function

    def from_string(string)
      unless valid_string?(string)
        raise InvalidString
      end

      Train.new(
        char: string.chars.first.capitalize,
        length: string.length,
        direction: get_direction(string),
        express: express_train?(string)
      )
    end

    def valid_string?(string)
      return false unless string.match?(VALID_STRING)
      string.chars.map(&:downcase).uniq.one?
    end

    def get_direction(string)
      case string
      when /\A.*[A-Z]\z/
        :clockwise
      when /\A[A-Z].+\z/
        :counterclockwise
      end
    end

    def express_train?(string)
      string.chars.first.capitalize == EXPRESS_TRAIN
    end
  end
end
