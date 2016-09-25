class AddNeedsToBeSentToEmail < ActiveRecord::Migration
  def change
    add_column :emails, :needs_to_be_sent, :bool
  end
end
