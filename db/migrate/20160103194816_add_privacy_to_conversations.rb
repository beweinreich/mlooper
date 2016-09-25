class AddPrivacyToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :privacy, "ENUM('private', 'public')"
  end
end
