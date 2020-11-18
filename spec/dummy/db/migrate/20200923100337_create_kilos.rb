class CreateKilos < ActiveRecord::Migration[6.0]
  def change
    create_table :kilos do |t|
      t.string :type
      t.string :encrypted_password
      t.string :reset_password_token
      t.string :reset_password_sent_at
      t.string :remember_created_at

      t.timestamps
    end
  end
end
