class AddHtmlToEmails < ActiveRecord::Migration
  def change
    add_column :emails, :html, :text
  end
end
