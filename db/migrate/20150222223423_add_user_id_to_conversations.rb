class AddUserIdToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :user_id, :integer
  end
end
