class RenameFromInConversation < ActiveRecord::Migration
  def change
		rename_column :conversations, :from, :looped_with
  end
end
