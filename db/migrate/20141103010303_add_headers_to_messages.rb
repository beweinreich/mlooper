class AddHeadersToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :headers, :text
  end
end
