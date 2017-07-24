class AddUserToIdea < ActiveRecord::Migration[5.1]
  def change
    add_reference :ideas, :user, foreign_key: true, index: true
  end
end
