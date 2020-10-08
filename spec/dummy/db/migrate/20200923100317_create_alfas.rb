class CreateAlfas < ActiveRecord::Migration[6.0]
  def change
    create_table :alfas do |t|
      t.boolean :boolean
      t.integer :integer
      t.decimal :decimal
      t.string :string

      t.timestamps
    end
  end
end
