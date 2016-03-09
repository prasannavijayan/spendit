class UserBudget < ActiveRecord::Base

  # Associations
  belongs_to :user
end

# == Schema Information
#
# Table name: user_budgets
#
#  id         :uuid            not null, primary key
#  budget     :float
#  user_id    :uuid
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

