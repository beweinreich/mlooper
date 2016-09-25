class RemoveRawBodyFromEmail < ActiveRecord::Migration
  def change
    remove_column :emails, :raw_body, :text
  end
end
