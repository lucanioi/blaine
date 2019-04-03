PROPERTIES = %i[length to_s direction express?]

PROPERTIES.each do |property|
  shared_examples property do |expected|
    it "#{property}: #{expected}" do
      expect(train.send(property)).to eq expected
    end
  end
end
