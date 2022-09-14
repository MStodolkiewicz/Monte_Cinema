class CreateSeances < ActiveRecord::Migration[7.0]
  def change
    create_table :seances do |t|
      t.datetime :start_time,  null: false
      t.datetime :end_time,  null: false
      t.float :price,  null: false
      t.references :hall, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true

      t.timestamps
    end
  end
end
