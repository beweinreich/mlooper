class AddSentToEmail < ActiveRecord::Migration
  def change
    add_column :emails, :sent, :integer, default: 0, null: false
  end
end
