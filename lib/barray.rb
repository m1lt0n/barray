require 'barray/version'

module Barray
  class InvalidPositionError < StandardError; end
  class LossyOperationError < StandardError; end

  class BitArray
    attr_reader :size

    def initialize(size)
      @size = size
      @byte_size = (size / 8.0).ceil
      @data = init_data
    end

    def dump
      data.dup
    end

    def load(data_in)
      raise LossyOperationError, 'Data size exceeds array size' if data_in.bytesize > byte_size

      self.data = data_in.dup << "\u0000" * (byte_size - data_in.bytesize)
    end

    def set(position)
      ensure_position!(position)
      data.setbyte(position / 8, (data.getbyte(position / 8) | (1 << (position % 8))))
    end

    def unset(position)
      ensure_position!(position)
      data.setbyte(position / 8, (data.getbyte(position / 8) & (255 ^ (1 << (position % 8)))))
    end

    def set?(position)
      ensure_position!(position)
      get(position) != 0
    end

    def get(position)
      ensure_position!(position)
      data.getbyte(position / 8) & (1 << (position % 8)) != 0 ? 1 : 0
    end

    def reset
      init_data
    end

    def toggle(position)
      ensure_position!(position)
      data.setbyte(position / 8, (data.getbyte(position / 8) ^ (1 << (position % 8))))
    end

    def each_bit
      return enum_for(:each_bit) unless block_given?

      size.times do |bit_position|
        yield get(bit_position)
      end
    end

    def set_size
      count = 0

      data.each_byte do |byte|
        next if byte.zero?

        count += byte.to_s(2).split('').reject { |bit| bit == '0' }.length
      end

      count
    end

    def unset_size
      size - set_size
    end

    private

    attr_accessor :byte_size, :data
    attr_writer :size

    def init_data
      self.data = "\u0000" * byte_size
    end

    def ensure_position!(position)
      raise InvalidPositionError, 'Position cannot exceed size' if position >= size
    end
  end
end
