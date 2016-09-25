class AddHilarityToConversation < ActiveRecord::Migration
  def change
    add_column :conversations, :hilarity, :int
  end
end
