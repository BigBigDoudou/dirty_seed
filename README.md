# DirtySeed

:seedling: Populate the database with records matching associations and validations in order to quickly test the application rendering.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dirty_seed', '~> 0.1.8'
```

And then execute:
```bash
$ bundle
```

## Usage

Once you've installed the gem, you can use the dedicated task.

To seed dirty data, run:

```bash
$ rake dirty_seed:seed
```

This will create `10` records for each model inheriting from `ApplicationRecord`.

You can change the number of records to seed by adding a `COUNT` variable:

```bash
$ rake dirty_seed:seed COUNT=42
```

Instance that cannot be saved are simply ignored.

For each model, the number of created created records and the recurrent errors are printed out:

```bash
rake dirty_seed:seed COUNT=15

User
  created: 15
Article
  created: 0
  errors: Title should contains the user name and the current date
```

### Database population

For each model inheriting from `ApplicationRecord`, records are created.

Models are sorted by their dependency to each others (through a `belongs_to` association) to ensure that some records exist before seeding an instance that requires one.

For instance, given the following models, the order of seeding will be `User`, `Article` and `Notification`:

```ruby
# app/models/article
class Article
  belongs_to :user
  has_many :notifications, as: :notifiable
end

class User
  has_many :articles
  has_many :notifications, as: :notifiable
end

class Notification
  belongs_to :notifiable, polymorphic: true
end
```

### Value assignment

A value is assigned for each attribute, depending on its type.

Special types (`hstore`, `json`, `jsonb`, `array`...) are currently ignored (no value assignment).

For instance, given the following schema:

```ruby
# db/schema.rb
create_table 'things' do |t|
  t.binary 'a_binary'
  t.boolean 'a_boolean'
  t.date 'a_date'
  t.datetime 'a_datetime'
  t.decimal 'a_decimal'
  t.integer 'an_integer'
  t.float 'a_float'
  t.string 'a_string'
  t.text 'a_text'
  t.time 'a_time'
end
```

...then a dirty seeded `thing` looks like:

```ruby
{
  id: 1,
  a_binary: '13',
  a_boolean: false,
  a_date: Wed, '02 Dec 2020',
  a_datetime: 'Sun, 08 Nov 2020 03:01:34 UTC +00:00',
  a_decimal: 19.8812490973183,
  an_integer: 6,
  a_float: 28.825997012616263,
  a_string: 'Maxime eum ratione ab quod nihil.',
  a_text: 'Autem non in est dolore.',
  a_time: 'Sat, 01 Jan 2000 09:31:22 UTC +00:00'
}
```

### Ignored attributes

Some "special" attributes are not getting a value because:
- Rails assigns it (STI type...);
- or the RDBMS (PostgreSQL, SQLite...) assigns it;
- or it is used in specific cases (authentication...).

These attributes are currently:

- `id`
- `created_at`
- `updated_at`
- `type` (for STI)
- `encrypted_password` (authentication usage)
- `reset_password_token` (authentication usage)
- `reset_password_sent_at` (authentication usage)
- `remember_created_at` (authentication usage)

### Associations

For attributes related to an association, an instance matching the `belongs_to` is assigned.

Polymorphic associations work too and only an instance of a model that `has_one` or `has_many` of this association can be assigned.

For instance, given the following schema:

```ruby
# schema.rb
create_table :notifications do |t|
  t.references :thing
  t.references :notifiable, polymorphic: true, null: false
  t.references :foo, null: false, foreign_key: { to_table: :things }
end
```

...and the models:

```ruby
# app/models/notification.rb
class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true
  belongs_to :thing
  belongs_to :bar, class_name: 'Thing', foreign_key: :foo_id
end

# app/models/user.rb
class User < ApplicationRecord
  has_many :notifications, as: :notifiable
end
```

...then a dirty seeded `notification` looks like:

```ruby
{
  :id => 1,
  :thing_id => 42,
  :notifiable_type => 'User',
  :notifiable_id => 6,
  :foo_id => 75
}

notification.notifiable.class # User
notification.thing.class # Thing
notification.bar.class # Thing
```

### Validations

For attributes requiring validations, assigned value is adapted.

Currently, the following validations are treated:

- `uniqueness`
- `absence`
- `inclusion: { in: [x, y] }`
- `numericality: { greater_than: x }`
- `numericality: { greater_than_or_equal_to: x }`
- `numericality: { lesser_than: x }`
- `numericality: { lesser_than_or_equal_to: x }`
- `numericality: { in: x..y }`

Custom validations are not inspected.

### Meaning detection

Some string attribute meanings are guessed by name: `email`, `first_name`, `latitude`...

Values are then built with the `faker` gem.

For instance, given the following schema:

```ruby
# db/schema.rb
create_table "users" do |t|
  t.string "first_name"
  t.string "last_name"
  t.string "address"
  t.string "city"
  t.string "country"
  t.string "email"
  t.string "password"
  t.string "phone"
  t.string "username"
  # ...
end
```

...then a dirty seeded `user` looks like:

```ruby
{
  id: 1,
  first_name: 'Emory',
  last_name: 'Franecki',
  address: '843 Schneider Squares, Port Olenmouth, TN 12657',
  city: 'Torpshire',
  country: 'United Arab Emirates',
  email: 'scottie_friesen@example.net',
  password: 'ZkUtNtFg4L',
  phone: '(814) 382-6102 x036',
  username: 'ernestine_rau',
  # ...
}
```

The current attribute names treated this way are:

- `address`
- `city`
- `color`
- `colour`
- `country`
- `currency`
- `description`
- `email`
- `first_name`
- `firstname`
- `last_name`
- `lastname`
- `lat`
- `latitude`
- `lng`
- `locale`
- `longitude`
- `middlename`
- `middle_name`
- `password`
- `phone`
- `phone_number`
- `reference`
- `title`
- `user_name`
- `username`
- `uuid`

More meanings will be added soon and will extend the mechanism to other formats (e.g. an `age` integer).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Next features and improvements

* Integrate more validations (length, exclusion, etc.).
* Assign values for more data types (json, array, etc.).
* Detect more meanings and extend it to other formats.
* Detect more "special" attributes to ignore.
* Use instance errors to adjust values and eventually match custom validations.
* Add a configuration system to define how to seed: models to skip, default values, etc.


