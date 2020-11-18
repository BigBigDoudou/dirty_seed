class CreateFoxtrots < ActiveRecord::Migration[6.0]
  def change
    create_table :foxtrots do |t|
      t.string :type

      t.timestamps
    end
  end
end
