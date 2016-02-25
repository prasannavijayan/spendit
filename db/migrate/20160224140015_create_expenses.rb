class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.text :title
      t.float :amount

      t.timestamps null: false
    end
  end
end
