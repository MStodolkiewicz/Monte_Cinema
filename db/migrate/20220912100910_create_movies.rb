class CreateMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.string :name,  null: false
      t.text :description
      t.integer :duration,  null: false

      t.timestamps
    end
  end
end
