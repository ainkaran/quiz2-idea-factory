class Like < ApplicationRecord
  belongs_to :user
  belongs_to :idea

  # The following garantees that there can be only one of the same question_id per
  # user_id. This means that a user can only like a question once.
  # question_id, user_id are from columns
  validates :idea_id, uniqueness:  {
    scope: :user_id,
    message: ->(object, data) do
      "You've already liked this #{data[:attribute].downcase}"
    end
  }
end
