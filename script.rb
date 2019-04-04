require_relative 'lib/blaine'

def train_crash(track_str, a_train_str, a_train_pos, b_train_str, b_train_pos, limit)
  track = Blaine::TrackBuilder.from_string(track_str)
  a_train = Blaine::TrainFactory.from_string(a_train_str)
  b_train = Blaine::TrainFactory.from_string(b_train_str)

  track.add_train(a_train, at: a_train_pos)
  track.add_train(b_train, at: b_train_pos)

  trains = [a_train, b_train]
  time = 0

  until time >= limit
    time += 1
    trains.map(&:move_forward)

    sleep 0.05
    puts `clear`
    puts "time passed: #{time}"
    puts track.to_s
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

train_a = 'Aaaa'
train_a_position = 147
train_b = 'Bbbbbbbbbbb'
train_b_position = 288
limit = 1000

train_crash(track, train_a, train_a_position, train_b, train_b_position, limit)
