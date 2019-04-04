begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  puts "Could not load rspec rake task"
end

task default: :spec

task :script do
  require 'pathname'
  root = Pathname.new(File.expand_path(__dir__))
  load "#{root}/script.rb"
end

task :pry do
  require File.join(__dir__, 'lib/blaine')
  Blaine.pry
end
