class AddDisabledToConversation < ActiveRecord::Migration
  def change
    add_column :conversations, :disabled, :boolean, default: 0, null: false
  end
end
