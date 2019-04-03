shared_examples :validate_connected do
  it 'track pieces connect' do
    run_method.each_cons(2) do |track, other_track|
      expect(track.next(:clockwise)).to be other_track
    end
  end
end

shared_examples :validate_loop do
  include_examples :validate_connected

  it 'track pieces loop' do
    track_pieces = run_method
    expect(track_pieces.first).to be_connected(track_pieces.last)
  end
end

shared_examples :validate_length do |length|
  it 'correct number of track pieces' do
    expected = length || number_of_track_chars + number_of_crossing_chars
    expect(run_method.size).to eq expected
  end
end

shared_examples :validate_crossings do |*chars|
  it 'forms a crossing correctly' do
    positions = run_method
                  .select { |tp| chars.include? tp.to_s }
                  .group_by { |tp| tp.position.to_a }

    positions.each do |_position, (first, second)|
      expect(first.crossing).to be second
    end
  end
end

shared_examples :validate_stations do |stations_count|
  it 'creates stations' do
    stations = run_method.select { |tp| tp.is_a? Blaine::Station }
    expected = stations_count || track_string.count('S')

    expect(stations.size).to eq expected
  end
end
