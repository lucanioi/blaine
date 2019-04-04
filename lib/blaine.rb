require 'pathname'
require 'pry'

module Blaine
  class << self
    def root_path
      Pathname.new(File.expand_path(__dir__ + '/..'))
    end

    def lib_path
      root_path + 'lib'
    end

    def setup_load_paths
      $LOAD_PATH.unshift(root_path) unless $LOAD_PATH.include? root_path
      $LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include? lib_path
    end

    def setup_requires
      Pathname.glob('lib/blaine/**/*.rb').sort.each do |path|
        require path
      end
    end

    def pry
      Pry.start(self)
    end
  end
end

Blaine.setup_load_paths
Blaine.setup_requires
