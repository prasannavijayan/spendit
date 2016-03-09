class Expense < ActiveRecord::Base

  # Associations
  belongs_to :user
end

# == Schema Information
#
# Table name: expenses
#
#  id         :uuid            not null, primary key
#  title      :text
#  amount     :float
#  user_id    :uuid
#  created_at :datetime        not null
#  updated_at :datetime        not null
#
