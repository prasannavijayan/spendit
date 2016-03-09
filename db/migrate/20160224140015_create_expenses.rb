class CreateExpenses < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'

    create_table :expenses, id: :uuid do |t|
      t.text :title
      t.float :amount
      t.uuid :user_id

      t.timestamps null: false
    end
  end
end
