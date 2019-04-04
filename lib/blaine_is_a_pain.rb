require_relative 'blaine'

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
  end

  -1
rescue Blaine::Crash
  return time
end
