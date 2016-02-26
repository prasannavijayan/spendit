class Expense < ActiveRecord::Base

  # Associations
  belongs_to :user
end

# == Schema Information
#
# Table name: expenses
#
#  id         :integer         not null, primary key
#  title      :text
#  amount     :float
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#
