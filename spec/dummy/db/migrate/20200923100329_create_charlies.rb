class CreateCharlies < ActiveRecord::Migration[6.0]
  def change
    create_table :charlies do |t|
      t.references :alfa, null: false, foreign_key: true
      t.json :a_json

      t.timestamps
    end
  end
end
