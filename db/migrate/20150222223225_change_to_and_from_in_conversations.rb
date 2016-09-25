class ChangeToAndFromInConversations < ActiveRecord::Migration
  def change
		rename_column :conversations, :to, :spammers_email
  end
end
