class CreateJulietts < ActiveRecord::Migration[6.0]
  def change
    create_table :julietts do |t|
      t.references :alfa, null: false, foreign_key: true
      t.string :a_string
      t.integer :an_integer

      t.timestamps
    end
  end
end
