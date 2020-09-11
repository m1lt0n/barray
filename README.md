# Barray

Welcome to Barray! Barray is a ruby implementation of bit array that allows creating, querying, storing and restoring a bit array.

Bit arrays are a compact, space efficient data structure that represent a group of boolean values. A very common use is in probabilistic data structures (like Bloom filter).

Since Ruby does not have a bit or byte data structure, the underlying data structure that stores the bit array in Barray is a string. This makes it super easy to get and store the underlying string in e.g. a file and restore it (e.g. when a service that uses the bit array restarts after a crash or after a deployment).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'barray'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install barray

## Usage

In order to create a bit array, only its size is required:

```ruby
# Create a bit array that can store 100 bits
arr = Barray::BitArray.new(100)
```

Some common operations on individual bits that Barray::BitArray supports:

```ruby
# set the 5th bit
arr.set(5)

# get the 5th bit
arr.get(5)

# unset the 5th bit
arr.unset(5)

# toggle the value of the 10th bit
arr.toggle(10)

# returns true if the bit is set
arr.set?(10)
```

The set and unset operations are idempotent, as the final state of the bit is the same. This is not the case with toggle, as it changes the bit value from 1 to 0 or 0 to 1.

Some operations that apply on the bit array itself:

```ruby
# resets the values of all bits to zero
arr.reset

# each_bit returns an iterator with the values of the bits
arr.each_bit do |bit_value|
  puts bit_value
end

# get the number of set bits
arr.set_size

# alternatively, get the number of unset bits
arr.unset_size
```

Finally, it is very easy to dump the bit array's data (string), which can be used in order to store the bit array's value (e.g. in a file or in a database) and restore the bit array from that value:

```ruby
arr_value = arr.dump # this can be stored in a file or in a database

# at another point (e.g. on service restart after a crash)
new_arr = Barray::BitArray.new(100)
new_arr.load(arr_value) # arr_value can be loaded from a file or a database
```

**Note**: The underlying string is duplicated, so loading a bit array is not affected by direct operations on the string value outside the Barray::BitArray public API.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/barray. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Barray project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/barray/blob/master/CODE_OF_CONDUCT.md).
