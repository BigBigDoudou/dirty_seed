class CreateJulietts < ActiveRecord::Migration[6.0]
  def change
    create_table :julietts do |t|
      t.references :alfa, null: false, foreign_key: true
      t.string :string
      t.integer :integer

      t.timestamps
    end
  end
end
