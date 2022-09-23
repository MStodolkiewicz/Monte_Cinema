class CreateDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :discounts do |t|
      t.integer :tickets_needed,  null: false
      t.integer :value,  null: false

      t.timestamps
    end
  end
end
