require_relative 'lib/blaine'

TRAIN_SPEED = 0.05

def train_crash(track_str, limit, train_config)
  track = Blaine::TrackBuilder.from_string(track_str)

  trains = train_config.reduce([]) do |arr, (train_str, position)|
    train = Blaine::TrainFactory.from_string(train_str)
    track.add_train(train, at: position)
    arr << train
  end

  time = 0

  until time >= limit
    time += 1
    trains.map(&:move_forward)

    sleep TRAIN_SPEED
    puts `clear`
    puts "time passed: #{time}"
    puts track.to_s
  end

  -1
rescue Blaine::Crash
  puts "\n**************** CRASH!!!!! ****************"
  return time
end

track = """\
                                /------------\\
/-------------\\                /             |
|             |               /              \\------------------------\\ /-\\ /-\\ /-\\ /-\\
|             |              /                                        | | | | | | | | |
|        /----+--------------+------\\                                 \\-/ | | | | | | |
\\       /     |              |      |        /----------\\                 \\-/ | | | | |
 \\      |     \\              |      |        |           \\----------\\         \\-/ | | |
 |      |      \\-------------+------+--------+---\\                  |             \\-/ |
 |      |                    |      |        |   |                  \\-----\\           |   /---------\\
 \\------+--------------------+------/        /   |                        |           |   |         |
        |                    |              /    \\------------------------+-----------+---+----\\    |
        \\------S-------------+-------------/                              |           |   |    |    |
                             |                   /------\\                 \\     /-----+---+----/    /
/-------------\\              |                   |       \\                 \\   /      |   |        /
|             |              |             /-----+----\\   \\                 \\ /       \\---/       /
|             |              |             |     |     \\   \\                 S                   /
\\-------------+--------------+-----S-------+-----/      \\   S               / \\                 /
              |              |             |             \\   \\             /   \\---------------/
              |              |             |             |    \\           /
              |              \\-------------+-------------/     \\---------/
              |                            |
              \\----------------------------/
"""

train_config = {
  'Aaaa' => 147,
  'Bbbbbbbbbbb' => 288,
  'xxxxxxxxxxxxxX' => 400,
  'qqqqQ' => 0,
}

limit = 50

train_crash(track, limit, train_config)
