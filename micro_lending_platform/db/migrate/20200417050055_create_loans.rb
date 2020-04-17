class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.integer :amount
      t.integer :period_in_days
      t.float :roi
      t.text :description

      t.timestamps null: false
    end
  end
end
