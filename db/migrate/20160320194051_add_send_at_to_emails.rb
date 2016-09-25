class AddSendAtToEmails < ActiveRecord::Migration
  def change
    add_column :emails, :send_at, :datetime
  end
end
