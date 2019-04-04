module Blaine
  class Track
    attr_reader :track_pieces, :trains

    def initialize(track_pieces)
      @track_pieces = track_pieces
      @trains = []
    end

    def add_train(train, at:)
      train.attach_to_track_piece(track_pieces[at])
      @trains << train
    end

    def to_s
      track_matrix.tap do |matrix|
        trains.each do |train|
          engine, *carriages = train.attached_track_pieces
          break unless engine
          matrix[engine.position.row][engine.position.column] = train.to_s

          carriages.each do |carriage|
            matrix[carriage.position.row][carriage.position.column] = train.to_s.downcase
          end
        end
      end.map(&:join).join("\n")
    end

    private

    def row_count
      1 + track_pieces.max_by { |tp| tp.position.row }.position.row
    end

    def column_count
      1 + track_pieces.max_by { |tp| tp.position.column }.position.column
    end

    def method_name

    end

    def track_matrix
      matrix = create_matrix.tap do |matrix|
        track_pieces.each do |tp|
          matrix[tp.position.row][tp.position.column] = tp.to_s
        end
      end
    end

    def create_matrix
      Array.new(row_count) { Array.new(column_count) { "\s" } }
    end
  end
end
