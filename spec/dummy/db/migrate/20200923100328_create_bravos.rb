class CreateBravos < ActiveRecord::Migration[6.0]
  def change
    create_table :bravos do |t|
      t.boolean :boolean, default: false, null: false
      t.integer :integer, null: false
      t.decimal :decimal, null: false
      t.string :string, null: false

      t.timestamps
    end
  end
end
