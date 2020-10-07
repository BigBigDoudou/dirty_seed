class CreateDeltas < ActiveRecord::Migration[6.0]
  def change
    create_table :deltas do |t|
      t.references :bravo, null: false, foreign_key: true
      t.references :zed, null: false, foreign_key: { to_table: :charlies }

      t.timestamps
    end
  end
end
