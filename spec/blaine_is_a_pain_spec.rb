require 'blaine_is_a_pain'

xdescribe 'Blaine is a Pain' do
  let(:train_track) do
"""\
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
  end

  let(:train_a) { 'Aaaa' }
  let(:train_a_position) { 147 }
  let(:train_b) { 'Bbbbbbbbbbb' }
  let(:train_b_position) { 288 }
  let(:limit) { 1000 }

  it 'determines the time left until trains crash' do
    time_left = train_crash(
      train_track,
      train_a,
      train_a_position,
      train_b,
      train_b_position,
      limit
    )

    expect(time_left).to eq 516
  end
end
