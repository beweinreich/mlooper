class AddRawBodyToEmail < ActiveRecord::Migration
  def change
    add_column :emails, :raw_body, :text
  end
end
