> **Work in progress!**

# DirtySeed

Populate the database with records matching associations and validations, in order to quickly test application.

## Usage

Once you've installed the gem, you can use the dedicated task.

To seed dirty data, run:
```bash
$ rake dirty_seed:seed
```

This will try to create instances for each of your models inheriting from `ApplicationRecord`.

If the instance cannot be saved, it is simply ignored.

Number of instances created and recurrent errors will be outputed.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dirty_seed', git: 'https://github.com/BigBigDoudou/dirty_seed'
```

And then execute:
```bash
$ bundle
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Next features

* Assign values for more data types (json, array, etc.).
* Integrate more validations (uniqueness, inclusion, length, absence, etc.).
* Use instance errors to adjust values.
* Add a configuration system to define how to seed: number of instances, models to skip, default values, etc.
