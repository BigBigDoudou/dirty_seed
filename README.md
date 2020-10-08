> **Work in progress!**

# DirtySeed

Populate the database with records matching associations and validations, in order to quickly test application.

## Usage

Once you've installed the gem, you can use the dedicated task.

To seed dirty data, run:
```bash
$ rake dirty_seed:seed
```

This will try to create five instances for each of your models inheriting from `ApplicationRecord`.

If the instance cannot be saved, it is simply ignored.

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

* Assign values for more data types (json, binary, etc.).
* Integrate more validations (uniqueness, inclusion, length, absence, etc.).
* Guess specific fields by name (email, password, etc.) and define adapted values.
* Get instance errors back and use them to adjust values.
* Add configuration so the client can define how to seed: number of instances, models to skip, default values, etc.
