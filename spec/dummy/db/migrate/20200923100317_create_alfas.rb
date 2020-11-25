class CreateAlfas < ActiveRecord::Migration[6.0]
  def change
    create_table :alfas do |t|
      t.boolean :a_boolean
      t.integer :an_integer
      t.decimal :a_decimal
      t.string :a_string
      t.date :a_date
      t.time :a_time
      t.datetime :a_datetime

      # automatic attributes
      t.string :type
      t.string :encrypted_password
      t.string :reset_password_token
      t.string :reset_password_sent_at
      t.string :remember_created_at

      t.timestamps
    end
  end
end
