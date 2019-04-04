require_relative 'lib/blaine'

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

def train_crash(track_str, a_train_str, a_train_pos, b_train_str, b_train_pos, limit)
  track_pieces = Blaine::TrackBuilder.to_track_pieces(track_str)

  a_train = Blaine::TrainFactory.from_string(a_train_str)
  b_train = Blaine::TrainFactory.from_string(b_train_str)

  a_train.attach_to_track_piece track_pieces[a_train_pos]
  b_train.attach_to_track_piece track_pieces[b_train_pos]

  trains = [a_train, b_train]
  time = 0

  until time >= limit
    time += 1
    trains.map(&:move_forward)

    sleep 0.05
    puts `clear`
    puts "time passed: #{time}"
    puts print_track(track_pieces, *trains)
  end

  -1
rescue Blaine::Crash
  return time
end

track = """\
                                /------------\\
/-------------\\                /             |
|             |               /              S
|             |              /               |
|        /----+--------------+------\\        |
\\       /     |              |      |        |
 \\      |     \\              |      |        |
 |      |      \\-------------+------+--------+---\\
 |      |                    |      |        |   |
 \\------+--------------------+------/        /   |
        |                    |              /    |
        \\------S-------------+-------------/     |
                             |                   |
/-------------\\              |                   |
|             |              |             /-----+----\\
|             |              |             |     |     \\
\\-------------+--------------+-----S-------+-----/      \\
              |              |             |             \\
              |              |             |             |
              |              \\-------------+-------------/
              |                            |
              \\----------------------------/
"""

train_a = 'Aaaaaaaaaaaaaaaaaaaaa'
train_a_position = 147
train_b = 'Xxx'
train_b_position = 288
limit = 1000

train_crash(track, train_a, train_a_position, train_b, train_b_position, limit)
