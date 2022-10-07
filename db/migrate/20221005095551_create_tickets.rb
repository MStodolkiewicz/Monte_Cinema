class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.integer :seat, null: false
      t.references :reservation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
