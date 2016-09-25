class AddReplyContentToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :reply_content, :text
  end
end
