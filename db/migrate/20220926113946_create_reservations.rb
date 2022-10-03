class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.integer :status, null: false, default: 0
      t.string :email, null: false
      t.references :seance, null: false, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
