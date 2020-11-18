class CreateIndias < ActiveRecord::Migration[6.0]
  def change
    create_table :indias do |t|
      t.references :hotel, null: false, foreign_key: true

      t.timestamps
    end

    add_reference :hotels, :india, foreign_key: true
  end
end
