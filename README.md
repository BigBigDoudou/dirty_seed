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

* Rely on Faker to define better values.
* Analyze mor validations (min and max length, inclusion in array, etc.).
* Read instance errors and use them to redefine valid values.
* Improve the logger to return what have been created and what have failed.
* Add a configuration file to define how many instances of each model to create, which models to skip, enforcing values...
