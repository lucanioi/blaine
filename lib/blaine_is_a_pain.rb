require_relative 'blaine'

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
  end

  -1
rescue Blaine::Crash
  return time
end
