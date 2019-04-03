# require 'lib/blaine/track'

def print_track(track_pieces, *trains)
  matrix = Blaine::Track.new(track_pieces).to_s.split("\n").map(&:chars)

  trains.each do |train|
    engine, *carriages = train.attached_track_pieces
    break unless engine
    matrix[engine.position.row][engine.position.column] = train.to_s

    carriages.each do |carriage|
      matrix[carriage.position.row][carriage.position.column] = train.to_s.downcase
    end
  end

  matrix.map(&:join).join("\n")
end
