RSpec.describe Barray do
  describe 'invalid position errors' do
    %i[get set unset toggle set?].each do |meth|
      it "##{meth} raises when trying to set position exceeding array size" do
        arr = Barray::BitArray.new(5)
        expect { arr.public_send(meth, 5) }.to raise_error Barray::InvalidPositionError
      end
    end
  end

  describe '#set' do
    it 'sets the bit to 1' do
      arr = Barray::BitArray.new(5)
      arr.set(3)

      [0, 1, 2, 4].each do |idx|
        expect(arr.get(idx)).to eq(0)
      end

      expect(arr.get(3)).to eq(1)
    end

    it 'is idempotent' do
      arr = Barray::BitArray.new(5)
      arr.set(3)
      arr.set(3)

      expect(arr.get(3)).to eq(1)
    end
  end

  describe '#unset' do
    it 'sets the bit to 0' do
      arr = Barray::BitArray.new(5)

      arr.set(3)
      expect(arr.get(3)).to eq(1)

      arr.unset(3)
      expect(arr.get(3)).to eq(0)
    end

    it 'is idempotent' do
      arr = Barray::BitArray.new(5)
      arr.set(3)
      arr.unset(3)
      arr.unset(3)

      expect(arr.get(3)).to eq(0)
    end
  end

  describe '#toggle' do
    it 'toggles the bit value' do
      arr = Barray::BitArray.new(5)
      arr.set(3)

      arr.toggle(3)
      expect(arr.get(3)).to eq(0)

      arr.toggle(3)
      expect(arr.get(3)).to eq(1)
    end
  end

  describe '#set?' do
    it 'checks if the bit is set' do
      arr = Barray::BitArray.new(5)
      arr.set(3)

      [0, 1, 2, 4].each do |idx|
        expect(arr.set?(idx)).to eq(false)
      end

      expect(arr.set?(3)).to eq(true)
    end
  end

  describe '#reset' do
    it 'sets all bits to zero' do
      arr = Barray::BitArray.new(5)

      arr.set(1)
      arr.set(3)
      expect(arr.get(1)).to eq(1)
      expect(arr.get(3)).to eq(1)

      arr.reset

      expect(arr.get(1)).to eq(0)
      expect(arr.get(3)).to eq(0)
    end
  end

  describe '#each_bit' do
    it 'returns an iterator with the bit values' do
      arr = Barray::BitArray.new(5)
      arr.set(1)
      arr.set(3)

      expect(arr.each_bit.to_a).to eq([0, 1, 0, 1, 0])
    end
  end

  describe '#dump' do
    it 'returns the underlying string that holds the bit array value' do
      arr = Barray::BitArray.new(10)
      arr.set(2)
      arr.set(9)

      expect(arr.dump.bytesize).to eq(2)
      expect(arr.dump.getbyte(0)).to eq(4)
      expect(arr.dump.getbyte(1)).to eq(2)
    end
  end

  describe '#set_size' do
    it 'returns the number of bits set' do
      arr = Barray::BitArray.new(10)
      arr.set(2)
      arr.set(5)
      arr.set(9)

      expect(arr.set_size).to eq(3)
    end
  end
  
  describe '#unset_size' do
    it 'returns the number of bits not set' do
      arr = Barray::BitArray.new(10)
      arr.set(2)
      arr.set(5)
      arr.set(9)

      expect(arr.unset_size).to eq(7)
    end
  end

  describe '#load' do
    it 'populates a bit array from an underlying string' do
      arr = Barray::BitArray.new(5)
      arr.set(1)
      arr.set(3)

      new_arr = Barray::BitArray.new(10)
      new_arr.load(arr.dump)

      [0, 2, 4, 5, 6, 7, 8, 9].each do |idx|
        expect(new_arr.get(idx)).to eq(0)
      end

      expect(new_arr.get(1)).to eq(1)
      expect(new_arr.get(3)).to eq(1)
    end

    it 'raises when the provided input string is larger than the size of the array' do
      arr = Barray::BitArray.new(10)

      expect { Barray::BitArray.new(3).load(arr.dump) }.to raise_error Barray::LossyOperationError
    end
  end
end
