class AddFeaturedToConversation < ActiveRecord::Migration
  def change
    add_column :conversations, :featured, :bool, default: false
  end
end
