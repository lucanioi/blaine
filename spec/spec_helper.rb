require 'pry'

module Blaine
  module SpecHelper
    def P(row, column)
      Blaine::Position.new(row, column)
    end
  end
end

RSpec.configure do |rspec|
  rspec.include Blaine::SpecHelper
end
