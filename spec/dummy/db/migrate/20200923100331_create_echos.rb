class CreateEchos < ActiveRecord::Migration[6.0]
  def change
    create_table :echos do |t|
      t.references :echoable, polymorphic: true
      t.timestamps
    end
  end
end
