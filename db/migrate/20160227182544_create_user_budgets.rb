class CreateUserBudgets < ActiveRecord::Migration
  def change
    create_table :user_budgets, id: :uuid do |t|
      t.float :budget
      t.uuid  :user_id
      t.timestamps null: false
    end
  end
end
