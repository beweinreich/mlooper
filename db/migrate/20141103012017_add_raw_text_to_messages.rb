class AddRawTextToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :raw_text, :text
  end
end
