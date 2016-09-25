class RemoveRawTextAndRawHeadersFromEmail < ActiveRecord::Migration
  def change
    remove_column :emails, :raw_text, :text
    remove_column :emails, :raw_headers, :text
  end
end
