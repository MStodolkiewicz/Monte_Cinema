class CreateHalls < ActiveRecord::Migration[7.0]
  def change
    create_table :halls do |t|
      t.integer :capacity,  null: false
      t.string :name,  null: false

      t.timestamps
    end
  end
end
