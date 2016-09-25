class AddPrivacyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :privacy, "ENUM('private', 'public')", default: 'public'
  end
end
