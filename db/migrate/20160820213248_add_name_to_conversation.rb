class AddNameToConversation < ActiveRecord::Migration
  def change
    add_column :conversations, :name, :string
  end
end
