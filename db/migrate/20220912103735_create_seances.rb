class CreateSeances < ActiveRecord::Migration[7.0]
  def change
    create_table :seances do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.float :price
      t.references :hall, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true

      t.timestamps
    end
  end
end
