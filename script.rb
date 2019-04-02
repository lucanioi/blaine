def print_track(track_pieces)
  max_row = track_pieces.max_by { |tp| tp.position.row }.position.row
  max_column = track_pieces.max_by { |tp| tp.position.column }.position.column

  matrix = Array.new(max_row + 1) { Array.new(max_column + 1) { "\s" } }

  track_pieces.each do |tp|
    matrix[tp.position.row][tp.position.column] = tp.to_s
  end

  matrix.map(&:join).join("/\n/")
end
