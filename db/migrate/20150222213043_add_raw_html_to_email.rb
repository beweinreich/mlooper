class AddRawHtmlToEmail < ActiveRecord::Migration
  def change
    add_column :emails, :raw_html, :text
  end
end
