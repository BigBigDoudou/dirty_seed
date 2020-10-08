class CreateJuliets < ActiveRecord::Migration[6.0]
  def change
    create_table :juliets do |t|
      t.references :alfa, null: false, foreign_key: true
      t.string :string
      t.integer :integer
      t.timestamps
    end
  end
end
