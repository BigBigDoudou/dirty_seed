class CreateBravos < ActiveRecord::Migration[6.0]
  def change
    create_table :bravos do |t|
      t.boolean :a_boolean, default: false, null: false
      t.integer :an_integer, null: false
      t.decimal :a_decimal, null: false
      t.string :a_string, null: false
      t.integer :a_unique_value
      t.string :a_string_from_options
      t.integer :an_integer_from_options
      t.string :an_absent_value
      t.string :a_regex
      t.integer :an_enum
      t.json :a_json
      t.text :an_array

      t.timestamps
    end
  end
end
