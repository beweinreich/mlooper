class RemoveRawHtmlAndRawBodyFromEmail < ActiveRecord::Migration
  def change
    remove_column :emails, :raw_html, :text
    remove_column :emails, :raw_body, :text
  end
end
