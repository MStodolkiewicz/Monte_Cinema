class CreateHalls < ActiveRecord::Migration[7.0]
  def change
    create_table :halls do |t|
      t.integer :capacity
      t.integer :number

      t.timestamps
    end
  end
end
